local high_str = require("high-str")

high_str.setup({
	verbosity = 0,
	saving_path = "/tmp/highstr/",
	highlight_colors = {
		-- color_id = {"bg_hex_code",<"fg_hex_code"/"smart">}
		color_0 = {"#0c0d0e", "smart"},	-- Cosmic charcoal
		color_1 = {"#e5c07b", "smart"},	-- Pastel yellow
		color_2 = {"#FF4500", "smart"},	-- Orange red
		color_3 = {"#008000", "smart"},	-- Office green
		color_4 = {"#0000FF", "smart"},	-- Just blue
		color_5 = {"#FFC0CB", "smart"},	-- Blush pink
		color_6 = {"#FFF9E3", "smart"},	-- Cosmic latte
		color_7 = {"#7d5c34", "smart"},	-- Fallow brown
		color_8 = {"#7FFFD4", "smart"},	-- Aqua menthe
		color_9 = {"#8A2BE2", "smart"},	-- Proton purple
	}
})

