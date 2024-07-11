@echo off

rem 拉取方案仓库

if exist "%~dp0rime-ice" (
    pushd "%~dp0rime-ice"
    git pull
    popd
) else (
    git clone https://github.com/iDvel/rime-ice.git "%~dp0rime-ice"
)

if exist "%~dp0rime-wubi" (
    pushd "%~dp0rime-wubi"
    git pull
    popd
) else (
    git clone https://github.com/mrshiqiqi/rime-wubi.git "%~dp0rime-wubi"
)

rem 拷贝通用配置文件

rmdir /q /s "%~dp0Common"
mkdir "%~dp0Common"
copy "%~dp0rime-ice\default.yaml" "%~dp0Common"
mkdir "%~dp0Common\opencc"
xcopy /s /e "%~dp0rime-ice\opencc" "%~dp0Common\opencc"

rem 拷贝拼音方案文件

rmdir /q /s "%~dp0RimeIce"
mkdir "%~dp0RimeIce"
mkdir "%~dp0RimeIce\cn_dicts"
xcopy /s /e "%~dp0rime-ice\cn_dicts" "%~dp0RimeIce\cn_dicts"
mkdir "%~dp0RimeIce\en_dicts"
xcopy /s /e "%~dp0rime-ice\en_dicts" "%~dp0RimeIce\en_dicts"
mkdir "%~dp0RimeIce\lua"
xcopy /s /e "%~dp0rime-ice\lua" "%~dp0RimeIce\lua"
copy "%~dp0rime-ice\melt_eng.dict.yaml" "%~dp0RimeIce"
copy "%~dp0rime-ice\melt_eng.schema.yaml" "%~dp0RimeIce"
copy "%~dp0rime-ice\radical_pinyin.dict.yaml" "%~dp0RimeIce"
copy "%~dp0rime-ice\radical_pinyin.schema.yaml" "%~dp0RimeIce"
copy "%~dp0rime-ice\rime_ice.dict.yaml" "%~dp0RimeIce"
copy "%~dp0rime-ice\symbols_v.yaml" "%~dp0RimeIce"
copy "%~dp0rime-ice\symbols_caps_v.yaml" "%~dp0RimeIce"
copy "%~dp0rime-ice\rime.lua" "%~dp0RimeIce\lua\rime_ice.lua"

copy "%~dp0rime-ice\double_pinyin.schema.yaml" "%~dp0RimeIce"
copy "%~dp0rime-ice\double_pinyin_abc.schema.yaml" "%~dp0RimeIce"
copy "%~dp0rime-ice\double_pinyin_flypy.schema.yaml" "%~dp0RimeIce"
copy "%~dp0rime-ice\double_pinyin_mspy.schema.yaml" "%~dp0RimeIce"
copy "%~dp0rime-ice\double_pinyin_sogou.schema.yaml" "%~dp0RimeIce"
copy "%~dp0rime-ice\double_pinyin_ziguang.schema.yaml" "%~dp0RimeIce"
copy "%~dp0rime-ice\rime_ice.schema.yaml" "%~dp0RimeIce"

rem 拷贝五笔方案文件

rmdir /q /s "%~dp0RimeWubi"
mkdir "%~dp0RimeWubi"
mkdir "%~dp0RimeWubi\lua"
xcopy /s /e "%~dp0rime-wubi\lua" "%~dp0RimeWubi\lua"
copy "%~dp0rime-wubi\pinyin.dict.yaml" "%~dp0RimeWubi"
copy "%~dp0rime-wubi\pinyin.schema.yaml" "%~dp0RimeWubi"
copy "%~dp0rime-wubi\punctuation.yaml" "%~dp0RimeWubi"
copy "%~dp0rime-wubi\quick_symbols.dict.yaml" "%~dp0RimeWubi"
rem copy "%~dp0rime-wubi\symbols.yaml" "%~dp0RimeWubi"
rem copy "%~dp0rime-wubi\wb_spelling.dict.yaml" "%~dp0RimeWubi"
copy "%~dp0rime-wubi\wb_spelling.schema.yaml" "%~dp0RimeWubi"
rem copy "%~dp0rime-wubi\wubi.dict.yaml" "%~dp0RimeWubi"
copy "%~dp0rime-wubi\wubi.extended.dict.yaml" "%~dp0RimeWubi"
copy "%~dp0rime-wubi\wubi.schema.yaml" "%~dp0RimeWubi"
copy "%~dp0rime-wubi\wubi_pinyin.schema.yaml" "%~dp0RimeWubi"
copy "%~dp0rime-wubi\rime.lua" "%~dp0RimeWubi\lua\rime_wubi.lua"

rmdir /q /s "%~dp0RimeWubiTables86"
rmdir /q /s "%~dp0RimeWubiTables98"
rmdir /q /s "%~dp0RimeWubiTables06"
mkdir "%~dp0RimeWubiTables86"
mkdir "%~dp0RimeWubiTables98"
mkdir "%~dp0RimeWubiTables06"
copy "%~dp0rime-wubi\tables\86\wubi.dict.yaml" "%~dp0RimeWubiTables86"
copy "%~dp0rime-wubi\tables\86\wb_spelling.dict.yaml" "%~dp0RimeWubiTables86"
copy "%~dp0rime-wubi\tables\98\wubi.dict.yaml" "%~dp0RimeWubiTables98"
copy "%~dp0rime-wubi\tables\98\wb_spelling.dict.yaml" "%~dp0RimeWubiTables98"
copy "%~dp0rime-wubi\tables\06\wubi.dict.yaml" "%~dp0RimeWubiTables06"
copy "%~dp0rime-wubi\tables\06\wb_spelling.dict.yaml" "%~dp0RimeWubiTables06"
