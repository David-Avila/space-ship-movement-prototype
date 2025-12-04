count = 209
count += 1

// Check for backups folder
if not file.exists("backups") then
	file.makedir "backups"	
end if

code = file.readLines("AutoSafe.ms")
code[0] = "count = " + count
file.writeLines "AutoSafe.ms", code

// generating backup
Backup = function
	file.makedir "backups/" + count
	folder = "backups/" + count + "/"
	
	for f in file.children
		// Checking if file is a miniscript file
		if f[f.len-3: f.len] == ".ms" then
			file.copy(f, folder + f)
		end if
	end for
	
end function

Backup