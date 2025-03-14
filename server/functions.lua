function sendToDiscord(message)
    local webhook = Config.webhook.url
    local embedData = {
        {
            ["color"] = Config.webhook.color,
            ["title"] = Config.webhook.title,
            ["description"] = message,
            ["footer"] = {
                ["text"] = Config.webhook.footer,
                ["icon_url"] = Config.webhook.image,
            }
        }
    }

    table.insert(embedData, embed)

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = Config.webhook.title, embeds = embedData}), { ['Content-Type'] = 'application/json' })
end