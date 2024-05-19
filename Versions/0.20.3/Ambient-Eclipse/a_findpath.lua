local BFS3D = load_script('Ambient-Eclipse:scripts/BFS3D.lua')
local BFS2D = load_script('Ambient-Eclipse:scripts/BFS2D.lua')
local MatrixPath = {}

local function tbl_reverse(tbl)
    local res = {}
    for indx, b in pairs(tbl) do
        indx = indx - 1
        res[#res + 1] = tbl[#tbl - indx]
    end
    return res
end

function MatrixPath.GameVector_Sort(tbl, x1, y1, z1)
    if tbl ~= -1 then
        if tbl[1][1] ~= x1 or tbl[1][2] ~= y1 or tbl[1][3] ~= z1 then
            tbl = tbl_reverse(tbl)
            return tbl
        else
            return tbl
        end
    else
        return -1
    end
end

function MatrixPath.MatrixVector_To_GameVector3D(path, size, x1, y1, z1)
    local path_table = {}
    if path then
        for _, point in ipairs(path) do
            --print(point[1], point[2])
            table.insert(path_table, {point[1] + x1 - size - 1, point[2] + y1 - size - 1, point[3] + z1 - size - 1})
        end
        return path_table
    else
        return -1 --Путь не найден
    end
end

function MatrixPath.MatrixVectorAI_To_GameVector3D(path, size, x1, y1, z1)
    local path_table = {}
    if path then
        for _, point in ipairs(path) do
            --print(point[1], point[2])
            pos_block = {point[1] + x1 - size - 1, point[2] + y1 - size - 1, point[3] + z1 - size - 1}
            if block.is_replaceable_at(pos_block[1], pos_block[2] - 1, pos_block[3]) then
                pos_block[2] = pos_block[2] - 1
            end
            table.insert(path_table, pos_block)
        end
        return path_table
    else
        return -1 --Путь не найден
    end
end

function MatrixPath.MatrixVector_To_GameVector2D(path, size, x1, y1, z1)
    local path_table = {}
    if path then
        for _, point in ipairs(path) do
            table.insert(path_table, {point[1] + x1 - size, y1, point[2] + z1 - size})
            --block.set(point[1] + x1 - size, y1, point[2] + z1 - size, 3, 0)
        end
        return path_table
    else
        return -1 --Путь не найден
    end
end

function MatrixPath.CreateZone3D(x1, y1, z1, x2, y2, z2, size) --Отправная точка, точка куда надо прийти, размер куба в котором будем искать то куда надо идти
    local zone = {}
    for x = x1 - size, x1 + size do
        for y = y1 - size, y1 + size do
            for z = z1 - size, z1 + size do
                local block_m = 0
                local matrixX = x - (x1 - size)
                local matrixY = y - (y1 - size)
                local matrixZ = z - (z1 - size)
                if block.is_replaceable_at(x, y, z) then
                    block_m = 0
                else
                    block_m = 1
                end
                if (x == x2 and y == y2 and z == z2) or (x == x1 and y == y1 and z == z1) then
                    block_m = 3
                end
                zone[#zone + 1] = {x = matrixX, y = matrixY, z = matrixZ, block = block_m}
            end
        end
    end
    return zone
end

local function if_block_jumped(x, y, z)
    if (block.get(x, y - 1, z) ~= 0) or 
    (block.get(x - 1, y - 1, z) ~= 0 or block.get(x + 1, y - 1, z) ~= 0 or block.get(x, y - 1, z - 1) ~= 0 or block.get(x, y - 1, z + 1) ~= 0) then
        return true
    else
        return false
    end
end

function MatrixPath.CreateZoneAI(x1, y1, z1, x2, y2, z2, size) --Отправная точка, точка куда надо прийти, размер куба в котором будем искать то куда надо идти
    local zone = {}
    for y = y1 - size, y1 + size do
        for x = x1 - size, x1 + size do
            for z = z1 - size, z1 + size do
                local block_m = 0
                local matrixX = x - (x1 - size)
                local matrixY = y - (y1 - size)
                local matrixZ = z - (z1 - size)
                if block.is_replaceable_at(x, y, z) and if_block_jumped(x, y, z) then
                    block_m = 0
                else
                    block_m = 1
                end
                if (x == x2 and y == y2 and z == z2) or (x == x1 and y == y1 and z == z1) then
                    block_m = 3
                end
                zone[#zone + 1] = {x = matrixX, y = matrixY, z = matrixZ, block = block_m}
            end
        end
    end
    return zone
end


function MatrixPath.CreateZone2D(x1, z1, x2, z2, y, size)
    local zone = {}
    for x = x1 - size, x1 + size do
        for z  = z1 - size, z1 + size do
            local block_m = 0
            local matrixX = x - (x1 - size)
            local matrixZ = z - (z1 - size)
            if block.is_replaceable_at(x, y, z) then
                block_m = 0
            else
                block_m = 1
            end
            if (x == x1 and z == z1) then block_m = 2
            elseif (x == x2 and z == z2) then block_m = 3 end
            zone[#zone + 1] = {x = matrixX, y = matrixZ, block = block_m}
        end
    end
    return zone
end

function MatrixPath.convertBlocksToMatrix2D(blocks)
    local matrix = {}
    local maxX, maxY = 0, 0
    local start, goal

    for _, block in ipairs(blocks) do
        maxX = math.max(maxX, block.x)
        maxY = math.max(maxY, block.y)
        if block.block == 2 then
            start = {block.x, block.y}
            block.block = 0
        elseif block.block == 3 then
            goal = {block.x, block.y}
            block.block = 0
        end
    end

    for _, block in ipairs(blocks) do
        local x, y = block.x, block.y
        matrix[x] = matrix[x] or {}
        matrix[x][y] = block.block
    end

    local astarMatrix = {}
    for x = 1, maxX do
        astarMatrix[x] = {}
        for y = 1, maxY do
            astarMatrix[x][y] = matrix[x] and matrix[x][y] == 0 and 0 or 1
        end
    end

    return astarMatrix, {start, goal}
end


function MatrixPath.convertBlocksToMatrix3D(blocks) --Конвертирует таблицу которую возвращает CreateZone и возвращает её вместе с таблицей, где переведены точки старта и завершения
    local matrix = {}
    local targetPoints = {}
    for _, block in ipairs(blocks) do
        local x = block.x + 1
        local y = block.y + 1
        local z = block.z + 1
        if block.block == 2 or block.block == 3 then
            matrix[x] = matrix[x] or {}
            matrix[x][y] = matrix[x][y] or {}
            if block.block == 2 then
                matrix[x][y][z] = block.block
            elseif block.block == 3 then
                matrix[x][y][z] = 0
                table.insert(targetPoints, {x, y, z})
            end
        else
            matrix[x] = matrix[x] or {}
            matrix[x][y] = matrix[x][y] or {}
            matrix[x][y][z] = block.block
        end
    end
    return matrix, targetPoints
end

function MatrixPath.Findpath3D(x1, y1, z1, x2, y2, z2, size)
    local blocks = MatrixPath.CreateZone3D(x1, y1, z1, x2, y2, z2, size)
    local matrix, cord = MatrixPath.convertBlocksToMatrix3D(blocks)
    local path = BFS3D:find(matrix, cord[1], cord[2])
    return MatrixPath.GameVector_Sort(MatrixPath.MatrixVector_To_GameVector3D(path, size, x1, y1, z1), x1, y1, z1)
end

function MatrixPath.Findpath2D(x1, z1, x2, z2, y, size)
    local blocks = MatrixPath.CreateZone2D(x1, z1, x2, z2, y, size)
    local matrix, cord = MatrixPath.convertBlocksToMatrix2D(blocks)
    local path = BFS2D:find(matrix, cord[1], cord[2])
    return MatrixPath.MatrixVector_To_GameVector2D(path, size, x1, y, z1)
end

function MatrixPath.FindpathAI(x1, y1, z1, x2, y2, z2, size)
    local blocks = MatrixPath.CreateZoneAI(x1, y1, z1, x2, y2, z2, size)
    local matrix, cord = MatrixPath.convertBlocksToMatrix3D(blocks)
    local path = BFS3D:find(matrix, cord[1], cord[2])
    return MatrixPath.GameVector_Sort(MatrixPath.MatrixVectorAI_To_GameVector3D(path, size, x1, y1, z1), x1, y1, z1)
end

return MatrixPath