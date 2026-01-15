--- Bump.lua plugin for STI
-- @module bump.lua
-- @author David Serrano (BobbyJones|FrenchFryLord)
-- @copyright 2019
-- @license MIT/X11

local lg = require((...):gsub('plugins.bump', 'graphics'))

return {
	bump_LICENSE        = "MIT/X11",
	bump_URL            = "https://github.com/karai17/Simple-Tiled-Implementation",
	bump_VERSION        = "3.1.7.1",
	bump_DESCRIPTION    = "Bump hooks for STI.",

	--- Adds each collidable tile to the Bump world.
	-- @param world The Bump world to add objects to.
	-- @return collidables table containing the handles to the objects in the Bump world.
	bump_init = function(map, world)
		local collidables = {}
		
		-- Helper function to get property value from Tiled's property array format
		local function getProperty(obj, propName)
			if not obj.properties then return nil end
			
			-- If properties is already a table (old format), return directly
			if type(obj.properties) == "table" and obj.properties[propName] ~= nil then
				return obj.properties[propName]
			end
			
			-- If properties is an array (new Tiled format), search for the property
			for i, prop in ipairs(obj.properties) do
				if prop.name == propName then
					return prop.value
				end
			end
			
			return nil
		end

		for _, tileset in ipairs(map.tilesets) do
			for _, tile in ipairs(tileset.tiles) do
				local gid = tileset.firstgid + tile.id

				if map.tileInstances[gid] then
					for _, instance in ipairs(map.tileInstances[gid]) do
						-- Every object in every instance of a tile
						if tile.objectGroup then
							for _, object in ipairs(tile.objectGroup.objects) do
								if getProperty(object, "collidable") == true then
									local t = {
										name       = object.name,
										type       = object.type,
										x          = instance.x + map.offsetx + object.x,
										y          = instance.y + map.offsety + object.y,
										width      = object.width,
										height     = object.height,
										layer      = instance.layer,
										properties = object.properties

									}

									world:add(t, t.x, t.y, t.width, t.height)
									table.insert(collidables, t)
								end
							end
						end

						-- Every instance of a tile
						if getProperty(tile, "collidable") == true then
							local t = {
								x          = instance.x + map.offsetx,
								y          = instance.y + map.offsety,
								width      = map.tilewidth,
								height     = map.tileheight,
								layer      = instance.layer,
								type       = tile.type,
								properties = tile.properties
							}

							world:add(t, t.x, t.y, t.width, t.height)
							table.insert(collidables, t)
						end
					end
				end
			end
		end

		for _, layer in ipairs(map.layers) do
			
			local layerCollidableProp = getProperty(layer, "collidable")
			
			if layer.properties and layer.properties.collidable == true then
				if layer.type == "tilelayer" then
					for y, tiles in ipairs(layer.data) do
						for x, tile in pairs(tiles) do

							if tile.objectGroup then
								for _, object in ipairs(tile.objectGroup.objects) do
									-- FIX: Check if properties exists before accessing it
									if getProperty(object, "collidable") == true then
										local t = {
											name       = object.name,
											type       = object.type,
											x          = ((x-1) * map.tilewidth  + tile.offset.x + map.offsetx) + object.x,
											y          = ((y-1) * map.tileheight + tile.offset.y + map.offsety) + object.y,
											width      = object.width,
											height     = object.height,
											layer      = layer,
											properties = object.properties
										}

										world:add(t, t.x, t.y, t.width, t.height)
										table.insert(collidables, t)
									end
								end
							end


							local t = {
								x          = (x-1) * map.tilewidth  + tile.offset.x + map.offsetx,
								y          = (y-1) * map.tileheight + tile.offset.y + map.offsety,
								width      = tile.width,
								height     = tile.height,
								layer      = layer,
								type       = tile.type,
								properties = tile.properties
							}

							world:add(t, t.x, t.y, t.width, t.height)
							table.insert(collidables, t)
						end
					end
				elseif layer.type == "imagelayer" then
					world:add(layer, layer.x, layer.y, layer.width, layer.height)
					table.insert(collidables, layer)
				end
		  end

			-- individual collidable objects in a layer that is not "collidable"
			-- or whole collidable objects layer
		  if layer.type == "objectgroup" then
				for _, obj in ipairs(layer.objects) do
					local objCollidableProp = getProperty(obj, "collidable")
					
					-- Check if either the layer or the object is marked as collidable
					local layerCollidable = layerCollidableProp == true
					local objCollidable = objCollidableProp == true
						
					-- If layer is collidable, all objects in it are collidable
					-- Otherwise, only objects with collidable property set to true
					if layerCollidable or objCollidable then
						-- Default to rectangle if shape is not specified
						if not obj.shape or obj.shape == "rectangle" then
							local t = {
								name       = obj.name,
								type       = obj.type,
								x          = obj.x + map.offsetx,
								y          = obj.y + map.offsety,
								width      = obj.width,
								height     = obj.height,
								layer      = layer,
								properties = obj.properties
							}

							if obj.gid then
								t.y = t.y - obj.height
							end

							world:add(t, t.x, t.y, t.width, t.height)
							table.insert(collidables, t)
						end
					end
				end
			end
		end

		map.bump_world       = world
		map.bump_collidables = collidables
	end,

	--- Remove layer
	-- @param index to layer to be removed
	bump_removeLayer = function(map, index)
		local layer = assert(map.layers[index], "Layer not found: " .. index)
		local collidables = map.bump_collidables

		-- Remove collision objects
		for i = #collidables, 1, -1 do
			local obj = collidables[i]

			-- FIX: Check if properties exist
			local layerCollidable = layer.properties and layer.properties.collidable == true
			local objCollidable = obj.properties and obj.properties.collidable == true

			if obj.layer == layer and (layerCollidable or objCollidable) then
				map.bump_world:remove(obj)
				table.remove(collidables, i)
			end
		end
	end,

	--- Draw bump collisions world.
	-- @param world bump world holding the tiles geometry
	-- @param tx Translate on X
	-- @param ty Translate on Y
	-- @param sx Scale on X
	-- @param sy Scale on Y
	bump_draw = function(map, tx, ty, sx, sy)
		lg.push()
		lg.scale(sx or 1, sy or sx or 1)
		lg.translate(math.floor(tx or 0), math.floor(ty or 0))

		local items = map.bump_world:getItems()
		for _, item in ipairs(items) do
			lg.rectangle("line", map.bump_world:getRect(item))
		end

		lg.pop()
	end
}

--- Custom Properties in Tiled are used to tell this plugin what to do.
-- @table Properties
-- @field collidable set to true, can be used on any Layer, Tile, or Object