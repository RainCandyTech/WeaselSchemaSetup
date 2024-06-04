local basic = require('lib/basic')
local map = basic.map
local index = basic.index
local utf8chars = basic.utf8chars
local matchstr = basic.matchstr

local function commit_text_processor(key, env)
	local engine = env.engine
	local context = engine.context
	local composition = context.composition
	local segment = composition:back()
	local input_text = context.input
	local schema_name=env.engine.schema.schema_name or ""
	local page_size = env.engine.schema.page_size
	local schema_id=env.engine.schema.schema_id or ""
	local candidate_count =0

	if input_text:find("^%p*(%a+%d*)$") then
		if context:has_menu() then
			candidate_count = segment.menu:candidate_count()
		end
		env.last_1th_text=context:get_commit_text() or ""
		env.last_2th_text={text="",type=""}
		env.last_3th_text={text="",type=""}
		if candidate_count>1 then
			env.last_2th_text=segment:get_candidate_at(1)
			if candidate_count>2 then
				env.last_3th_text=segment:get_candidate_at(2)
			end
		end
	end

	-- `引导自造词记录保存
	-- 0x20空格，0x31大键盘数字1
	if input_text:find("^%`*(%l+%`%l+)") then
		local commit_text=context:get_commit_text() or ""
		if commit_text~="" and not commit_text:find("(%a)") and utf8.len(commit_text)>1 then
			env.userphrase=commit_text
			if segment.prompt:find('(%a+)') then
				env.inputtext=segment.prompt:gsub('[^%a]','')
			else
				env.inputtext=input_text
			end
		end
	else
		if key.keycode==0x20 or key.keycode>0x30 and key.keycode<0x39 then
			if env.userphrase~="" and env.userphrase~=nil and userphrasepath~="" then
				-- engine:commit_text(env.userphrase..env.inputtext.."\r")
				fileappendtext(userphrasepath,env.userphrase,env.inputtext,schema_name)
				env.userphrase=""
				env.inputtext=""
			end
		end
	end

	if key.keycode==0x27 and context:is_composing() and env.last_3th_text.text~="" then
		if env.last_3th_text.type=="reverse_lookup" or env.last_3th_text.type=="table" then
			context:clear()
			engine:commit_text(env.last_3th_text.text)
			return 1
		end
	end

	local m,n=input_text:find("^(%a+%d*)([%[%/%]\\])")
	if n~=nil and m~=nil then
		if (context:is_composing()) then
			-- local focus_text = context:get_commit_text()
			-- engine:commit_text(focus_text)
			context:clear()
			if input_text:find("^%u+%l*%d*") then   -- 大写字母引导的日期反查与转换功能，[ 和 ] 分别对应二选三选
				if input_text:find("%[") then
					engine:commit_text(env.last_2th_text.text)
				elseif input_text:find("%]") then
					engine:commit_text(env.last_3th_text.text)
				end
			else
				engine:commit_text(env.last_1th_text..CandidateText[1])  -- 第1个候选标点符号
			end
			return 1
		end
	end
	return 2
end

-- 记录自造词、文件路径userphrasepath在rime.lua中定义
function fileappendtext(filepath,context,input,schemaname)
	if not context:find('%a') then
		input=splitinput(input,utf8.len(context))
		context=context.."\t"..input.."\t〈"..schemaname.."〉"
		local f=io.open(filepath,"a+")
		local usertext=f:read("*a")
		if not usertext:find("[\r\n]*"..context) then
			f:write(context.."\r")
		end
		f:close()
	end
end

-- 格式化五笔组合编码
function splitinput(input,len)
	input="`"..input:gsub("%`*$","")
	if len==2 and input:find("(%`%l%l+%`%l%l+)") then
		input=input:gsub('(%`%l%l)%l*(%`%l%l)%l*', '%1%2')
		return input:gsub('%`', '')
	elseif len==3 and input:find("(%`%l%l+%`%l%l+%`%l%l+)") then
		input=input:gsub('(%`%l)%l+(%`%l)%l+(%`%l%l)%l*', '%1%2%3')
		return input:gsub('%`', '')
	elseif len>3 and input:find("(%`%l%l+%`%l%l+%`%l%l+.*%`%l%l+)$") then
		input=input:gsub('(%`%l)%l+(%`%l)%l+(%`%l).*(%`%l)%l+$', '%1%2%3%4')
		return input:gsub('`', '')
	else
		return input:gsub('^%`*', '')
	end
end

return commit_text_processor