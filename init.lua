local box_stuff = {
    {name = "default:diamond", chance = 3, max = 10},
    {name = "default:gold_ingot", chance = 5, max = 15},
    {name = "default:steel_ingot", chance = 1, max = 20},
    {name = "default:bronze_ingot", chance = 10, max = 30},
}

minetest.register_tool("box:key", {
	description = "Key For The Box",
	inventory_image = "keys_key.png",
})

minetest.register_node("box:box", {
	description = "box",
	tiles = {"default_wood.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {choppy = 2},
	on_punch = function(pos, node, player, pointed_thing)
		local playerName = player:get_player_name();
		local playerInv = player:get_inventory();
		local wielded = player:get_wielded_item()

		if wielded:get_name() ~= "box:key" then
			return
		end

		local luck = {}
		for s = 1, #box_stuff do
			for k = 1, box_stuff[s].chance do
				table.insert(luck, {name = box_stuff[s].name, max = box_stuff[s].max})
			end
		end

		local stuff = luck[math.random(1, #luck)]
		local num = stuff.max 
		local item = stuff.name

		local itemStackToAdd = playerInv:add_item("main", ItemStack(item .. " " .. num))
		if not itemStackToAdd:is_empty() then
			local pos_drop = { x=pos.x, y=pos.y+1, z=pos.z }
			minetest.spawn_item(pos_drop, ItemStack(item .. " " .. num)) 
		end

		playerInv:remove_item("main", "box:key 1")
	end,
})

local players_24h = {}

minetest.register_globalstep(function(dtime)
        for _, player in ipairs(minetest.get_connected_players()) do
        local name = player:get_player_name()
players_24h[name] = (players_24h[name] or 0) + dtime
        if players_24h[name] > 86400 then -- 24 hours in seconds
players_24h[name] = 0
        local inv = player:get_inventory()
inv:add_item("main", "box:key 1")
        end
    end
end)
