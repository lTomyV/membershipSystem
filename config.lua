Config = {}
Config.debug = true
Config.webhook = {
    url = "https://discord.com/api/webhooks/yourwebhook",
    image = "https://cdn.discordapp.com/attachments/yourimage.png",
    color = 16711680,
    title = "Membership System",
    footer = "Membership System",
}

Config.paymentDelay = 30 -- Minutos

Config.ranks = {
    bronce = {label = "Bronce", color = "brown", coinPayment = 1000},
    plata = {label = "Plata", color = "grey", coinPayment = 2000},
    oro = {label = "Oro", color = "gold", coinPayment = 3000},
    diamond = {label = "Diamond", color = "blue", coinPayment = 4000},
}

Config.commands = {
    addCoins = {cmd = "addcoins", dsc = "Add donator coins"},                  -- /addcoins [id] [amount]
    removeCoins = {cmd = "removecoins", dsc = "Remove donator coins"},          -- /removecoins [id] [amount]
    setCoins = {cmd = "setcoins", dsc = "Set donator coins"},                   -- /setcoins [id] [amount]
    addMembership = {cmd = "addmembership", dsc = "Add membership to player"},  -- /addmembership [id] [rank]
    removeMembership = {cmd = "removemembership", dsc = "Remove membership"},   -- /removemembership [id]
}