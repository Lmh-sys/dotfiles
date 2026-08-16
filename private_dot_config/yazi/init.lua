-- 1. 启用完整边框，让三栏布局在终端中更清晰
require("full-border"):setup {
	type = ui.Border.ROUNDED,
}

-- 2. 让 l 键在目录和文件之间使用一致的进入/打开行为
require("smart-enter"):setup {
	open_multi = true,
}

-- 3. 使用 Starship 渲染头部路径信息
require("starship"):setup {
	hide_flags = false,
	flags_after_prompt = true,
	show_right_prompt = false,
	hide_count = false,
	count_separator = " ",
}
