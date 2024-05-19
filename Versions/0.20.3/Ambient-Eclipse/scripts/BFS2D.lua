local BFS2D = {}

-- Функция для проверки, является ли точка внутренней матрицы и проходимой
local function isValid(x, y, matrix)
    return x >= 1 and x <= #matrix and y >= 1 and y <= #matrix[1] and matrix[x][y] == 0
end

-- Функция для поиска кратчайшего пути
function BFS2D:find(matrix, start, goal)
    local directions = {{-1, 0}, {0, -1}, {1, 0}, {0, 1}}  -- Возможные направления: вверх, влево, вниз, вправо

    local queue = {}  -- Очередь для BFS
    local visited = {}  -- Посещенные точки
    local parent = {}  -- Родительские точки для восстановления пути

    table.insert(queue, start)
    visited[start[1]] = {}
    visited[start[1]][start[2]] = true

    while #queue > 0 do
        local current = table.remove(queue, 1)

        if current[1] == goal[1] and current[2] == goal[2] then
            -- Путь найден, восстановим его
            local path = {}
            local node = goal

            while node do
                table.insert(path, 1, node)
                node = parent[node[1]] and parent[node[1]][node[2]]
            end

            return path
        end

        for _, dir in ipairs(directions) do
            local nextX, nextY = current[1] + dir[1], current[2] + dir[2]

            if isValid(nextX, nextY, matrix) and (not visited[nextX] or not visited[nextX][nextY]) then
                table.insert(queue, {nextX, nextY})
                visited[nextX] = visited[nextX] or {}
                visited[nextX][nextY] = true
                parent[nextX] = parent[nextX] or {}
                parent[nextX][nextY] = current
            end
        end
    end

    -- Если мы дошли сюда, путь не найден
    return nil
end

-- Тестирование
--local matrix = {
    --{0, 1, 0, 0, 0},
    --{0, 1, 0, 1, 0},
    --{0, 0, 0, 1, 0},
    --{0, 1, 0, 0, 0},
    --{0, 0, 0, 1, 0}
--}

--local start = {1, 1}
--local goal = {5, 5}

--local path = findPath(matrix, start, goal)

--if path then
    --print("Кратчайший путь найден:")
    --for _, point in ipairs(path) do
        --print("(" .. point[1] .. ", " .. point[2] .. ")")
    --end
--else
    --print("Путь не найден.")
--end

return BFS2D
