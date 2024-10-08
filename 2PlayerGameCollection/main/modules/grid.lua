---@diagnostic disable: empty-block
-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local M = {}

function M.create_grid(grid_size, tile_size, grid_pos) --grid_pos => scene_pos, not screen_pos!!!
    local grid = {}
    grid.grid_size = grid_size
    grid.tile_size = tile_size
    grid.grid_pos = grid_pos -- Center of the Grid!
    grid.start_pos = vmath.vector3(grid_pos.x - ((grid_size.x * tile_size.x)/2), grid_pos.y - ((grid_size.y * tile_size.y)/2), 0)
    --Position for GameObject with pivot on the center
    grid.start_pos_center = vmath.vector3(grid_pos.x - ((grid_size.x * tile_size.x)/2) + tile_size.x/2, grid_pos.y - ((grid_size.y * tile_size.y)/2) +  tile_size.y/2, 0)
    return grid
end

function M.is_Point_in_grid(grid, position_to_check)
    -- if position x is outside of the grid range, then return false
    if position_to_check.x < grid.start_pos.x or position_to_check.x > grid.start_pos.x + (grid.grid_size.x * grid.tile_size.x) then
        return false
    end
    -- if position y is outside of the grid range, then return false
    if position_to_check.y < grid.start_pos.y or position_to_check.y > grid.start_pos.y + (grid.grid_size.y * grid.tile_size.y) then
        return false
    end
    return true
end

function M.convert_from_id_to_multiple(grid, id)
    local y_id = math.floor(id / grid.grid_size.x)
    local x_id = math.floor(id - (y_id * grid.grid_size.x))
    return x_id, y_id
 end

 function M.convert_from_multiple_to_id(grid, id_x, id_y)
    return id_y * grid.grid_size.x + id_x
 end

function M.get_id_from_position(grid, scene_pos)
    local is_on_grid = M.is_Point_in_grid(grid, scene_pos)
    if is_on_grid == true then
        local x_dist = scene_pos.x - grid.start_pos.x
        local x_id = math.floor(x_dist / grid.tile_size.x)
        local y_dist = scene_pos.y - grid.start_pos.y
        local y_id =  math.floor(y_dist / grid.tile_size.y)
        return y_id * grid.grid_size.x + x_id
    else
        return -1
    end
 end

 function M.get_position_from_id(grid, id)
    local x_id, y_id = M.convert_from_id_to_multiple(grid, id)
    local scene_pos_x = math.floor(grid.start_pos_center.x + (x_id * grid.tile_size.x))
    local scene_pos_y = math.floor(grid.start_pos_center.y + (y_id * grid.tile_size.y))
    return vmath.vector3(scene_pos_x, scene_pos_y, 0.5)
 end

return M