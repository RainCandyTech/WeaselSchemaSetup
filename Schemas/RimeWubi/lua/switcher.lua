--[[
switch_keyword关键字更换在rime.lua文件rv_var中
须将 lua_processor@switch_processor 放在 engine/processors 里，并位于默认 selector 之前
--]]

local kRejected = 0
local kAccepted = 1
local kNoop = 2

-- 帮助函数，返回被选中的候选的索引
local function select_index(key, env)
	local ch = key.keycode
	local index = -1
	local select_keys = env.engine.schema.select_keys

	if select_keys ~= nil and select_keys ~= "" and not key.ctrl() and ch >= 0x20 and ch < 0x7f then
		local pos = string.find(select_keys, string.char(ch))
		if pos ~= nil then index = pos end
	elseif ch >= 0x30 and ch <= 0x39 then
		index = (ch - 0x30 + 9) % 10
	elseif ch >= 0xffb0 and ch < 0xffb9 then
		index = (ch - 0xffb0 + 9) % 10
	elseif ch == 0x20 then
		index = 0
	end
	return index
end

-- 切换开关函数
local function apply_switch(env, keyword, target_state)
	local context = env.engine.context
	local switcher = env.switcher
	local config = switcher.user_config
	context:set_option(keyword, target_state)
	-- 如果设置了自动保存，则需相应的配置
	if switcher:is_auto_save(keyword) and config ~= nil then
		config:set_bool("var/option/" .. keyword, target_state)
		-- switcher:refresh_menu(keyword)
	end
end

local function get_switches_list(key, env)
	local config =env.engine.schema.config
	local size=config:get_list_size("switches")
	local switches_list={}
	for i =1, size do
		table.insert(switches_list,{config:get_string("switches/@" .. i-1 .. "/name"),config:get_string("switches/@" .. i .. "/reset")})
	end
	return switches_list
end

local function get_switch_states(list,name)
	if type(list)~="table" then return "" end
	for i =1, #list do
		if list[i][1]==name then return list[i][2] end
	end
	return ""
end

local function IsExistChar(obj,chars)
	if type(obj)~="table" or chars=="" then return "" end
	for i =1,#obj do
		if obj[i][2]==chars then return obj[i][1] end
	end
	return ""
end

local function get_switch_keywords(obj,chars)
	if type(obj)~="table" or chars=="" then return "" end
	for i =1,#obj do
		if obj[i][1]==chars or obj[i][2]==chars then return obj[i][3] end
	end
	return ""
end

local function selector(key, env)
	if env.switcher == nil then return kNoop end
	if key:release() or key:alt() then return kNoop end
	local context = env.engine.context
	if (context:is_composing()) then
		local idx = select_index(key,env)
		if idx < 0 then return kNoop end
		local composition = context.composition
		local segment = composition:back()
		local codetext=env.engine.context.input
		local schema_name=env.engine.schema.schema_name or ""
		local candidate_count = segment.menu:candidate_count()
		local selected_candidate=segment:get_selected_candidate() or ""
		local page_pos= math.modf( segment.selected_index/page_size )+1
		local trad_mode=env.engine.context:get_option(trad_keyword)
		-- if segment.selected_index>page_size then
		-- 	local candidate_pos= math.fmod( segment.selected_index, page_size )
		-- end
		if page_pos>1 then idx=(page_pos-1)*page_size+idx end
		if candidate_count then
			local last_candidate=selected_candidate.text
			if key.keycode>0x2f and key.keycode<0x6a and idx>-1 then
				last_candidate=segment:get_candidate_at(idx).text or ""
			end
			if context.input == rv_var.switch_schema and last_candidate and not trad_mode then	-- 控制关键字切换方案
				local sc_id= IsExistChar(enable_schema_list,last_candidate)
				-- env.engine:commit_text(last_candidate.."-"..sc_id)
				-- context:clear()
				if sc_id:find("%a") then
					env.engine:apply_schema(Schema(sc_id))
					return kAccepted
				end
			elseif context.input == rv_var.switch_keyword and last_candidate or trad_mode and context.input == rv_var.switch_schema and last_candidate then	-- 关键字切换方案选项开关，如简繁切换、拆分开关等等
				local keyword=get_switch_keywords(candidate_keywords,last_candidate)
				-- env.engine:commit_text(last_candidate .. "-" .. keyword)
				if keyword~="" then
					local flag=env.engine.context:get_option(keyword)
					if flag~=nil then
						if env.engine.context:get_option(keyword) then apply_switch(env, keyword, false) else apply_switch(env, keyword, true) end
						context:clear()
						return kAccepted
					end
				end
			end
		end
	end

	return kNoop
end

-- 初始化
local function init(env)
	if Switcher == nil then return end
	env.switcher = Switcher(env.engine)
	page_size = env.engine.schema.page_size
end

return { init = init, func = selector }