local BFS3D = {}

-- Функция для проверки, является ли точка внутренней матрицы и проходимой
local function isValid(x, y, z, matrix)
    return x >= 1 and x <= #matrix and y >= 1 and y <= #matrix[1] and z >= 1 and z <= #matrix[1][1] and matrix[x][y][z] == 0
end

-- Функция для поиска кратчайшего пути
function BFS3D:find(matrix, start, goal)
    local directions = {{-1, 0, 0}, {0, -1, 0}, {1, 0, 0}, {0, 1, 0}, {0, 0, -1}, {0, 0, 1}}  -- Возможные направления в трехмерном пространстве

    local queue = {}  -- Очередь для BFS
    local visited = {}  -- Посещенные точки
    local parent = {}  -- Родительские точки для восстановления пути

    table.insert(queue, start)
    visited[start[1]] = {}
    visited[start[1]][start[2]] = {}
    visited[start[1]][start[2]][start[3]] = true

    while #queue > 0 do
        local current = table.remove(queue, 1)

        if current[1] == goal[1] and current[2] == goal[2] and current[3] == goal[3] then
            -- Путь найден, восстановим его
            local path = {}
            local node = goal

            while node do
                table.insert(path, 1, node)
                node = parent[node[1]] and parent[node[1]][node[2]] and parent[node[1]][node[2]][node[3]]
            end

            return path
        end

        for _, dir in ipairs(directions) do
            local nextX, nextY, nextZ = current[1] + dir[1], current[2] + dir[2], current[3] + dir[3]

            if isValid(nextX, nextY, nextZ, matrix) and (not visited[nextX] or not visited[nextX][nextY] or not visited[nextX][nextY][nextZ]) then
                table.insert(queue, {nextX, nextY, nextZ})
                visited[nextX] = visited[nextX] or {}
                visited[nextX][nextY] = visited[nextX][nextY] or {}
                visited[nextX][nextY][nextZ] = true
                parent[nextX] = parent[nextX] or {}
                parent[nextX][nextY] = parent[nextX][nextY] or {}
                parent[nextX][nextY][nextZ] = current
            end
        end
    end

    -- Если мы дошли сюда, путь не найден
    return nil
end

return BFS3D