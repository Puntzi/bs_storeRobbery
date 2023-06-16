Config = Config or {}

Config.debugPoly = false -- Si quereis ver los cuadrados

Config.Items = {
    shelfs = {
        {item = 'water_bottle', amount = 1},
        {item = 'sandwich', amount = 1},
        {item = 'lighter', amount = 1},
    }

    cashRegister = {
        type = 'cash',
        amount = 500,
    }

    safe = {
        {item = 'water_bottle', amount = 3},
        {item = 'sandwich', amount = 4},
    }
}

Config.shelfs = {
    {
        coords = vec4(-48.86, -1755.31, 29.42, 0.0),
        length = 1,
        width = 1,
        cooldown = 2, -- Esto són minutos
    },
}

Config.cashRegister = {
    {
        coords = vec4(-46.73, -1757.95, 29.42, 0.0),
        length = 1,
        width = 1,
        cooldown = 2, --Eso són minutos
    },
}

Config.safe = {
    {
        coords = vec4(-43.49, -1748.42, 29.42 ,0.0),
        length = 1,
        width = 1,
        cooldown = 2, -- Eso són minutos
    }
}