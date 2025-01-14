local M = {}
-- tell linter that cx and ya are global
local cx, ya, Command = cx, ya, Command

function M:peek(job)
	-- just the last file name, no path, no extension
	local home = os.getenv("HOME")
	local cache_file = home .. "/.cache/ya-preview.md"

	local ipynb_to_md = Command("ipynb-to-md")
		:args({ "-i", tostring(job.file.url), "-o", cache_file })
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:spawn()

	local _, ipynb_err = ipynb_to_md:wait()
	if ipynb_err then
		ya.err("ipynb-to-md failed: " .. tostring(ipynb_err))
		return
	end

	local mdcat = Command("mdcat")
		:args({ cache_file })
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:spawn()

	local _, mdcat_err = mdcat:wait()
	if mdcat_err then
		ya.err("mdcat failed: " .. tostring(mdcat_err))
		return
	end

	local limit = job.area.h
	local i, lines = 0, ""
	repeat
		local next, event = mdcat:read_line()
		if event == 1 then
			ya.err(tostring(event))
		elseif event ~= 0 then
			break
		end

		i = i + 1
		if i > job.skip then
			lines = lines .. next
		end
	until i >= job.skip + limit

	mdcat:start_kill()
	ipynb_to_md:start_kill()
	if job.skip > 0 and i < job.skip + limit then
		ya.manager_emit(
			"peek",
			{
				tostring(math.max(0, i - limit)),
				only_if = tostring(job.file.url),
				upper_bound = ""
			}
		)
	else
		lines = lines:gsub("\t", string.rep(" ", PREVIEW.tab_size))
		ya.preview_widgets(job, { ui.Text.parse(lines):area(job.area) })
	end
end

function M:seek(job)
	local h = cx.active.current.hovered
	if h and h.url == job.file.url then
		local step = math.floor(job.units * job.area.h / 10)
		ya.manager_emit("peek", {
			tostring(math.max(0, cx.active.preview.skip + step)),
			only_if = tostring(job.file.url),
		})
	end
end

return M
