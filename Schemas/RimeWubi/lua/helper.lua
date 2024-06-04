-- helper.lua
-- List features and usage of the schema.

local function translator(input, seg,env)
	local composition = env.engine.context.composition
	local segment = composition:back()
	if input==rv_var.help then
		local table = {
			{ '时间输出','→ '..rv_var.date_var .. '｜' .. rv_var.time_var.. '｜' .. rv_var.week_var}
			, { '历法节气','→ '..rv_var.nl_var .. '｜' .. rv_var.jq_var}
			, { '农历反查', '→ 两个等于号+数字日期' }
			, { '功能切换','→ '..rv_var.switch_keyword }
			, { '方案切换','→ '..rv_var.switch_schema }
			, { '注解上屏', '→ Ctrl + Shift + Return' }
			, { '折分显隐', '→ Ctrl+Shift+H' }
			, { '注解切换', '→ Ctrl+Shift +J' }
			, { '单字模式', '→ Ctrl+Shift+D' }
			, { '繁简切换', '→ Ctrl+Shift+F' }
			, { 'GB2312过滤', '→ Ctrl+Shift+U' }
			, { '计算器&金额大写', '→ 一个等于号+数字' }
			, { '临时拼音', '→ z键引导临时拼音' }
			, { '重复历史', '→ z键兼有重复历史' }
			, { '以形查音', '→ ~键引导以形查音' }
			, { '自造词', '→ `键引导自造词' }
			, { '选单', '→ Ctrl+` 或 F4' }
			-- , { 'lua字符串', '→ 以大写字母开头触发' }
			, { '帮助', '→ '..rv_var.help }
			, { '作者', '空山明月' }
			, { '五笔方案地址', 'https://gitee.com/hi-coder/rime-wubi' }
			, { '中书君地址', 'https://gitee.com/hi-coder/WubiMaster' }
		}
		segment.prompt ='简要说明'
		for k, v in ipairs(table) do
			local cand = Candidate('help', seg.start, seg._end, v[1], ' ' .. v[2])
			-- cand.preedit = input .. '\t简要说明'
			-- cand.quality=100000000
			yield(cand)
		end
	end
end

return translator
