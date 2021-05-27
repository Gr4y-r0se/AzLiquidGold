
def save(target,results,results2=[])
	filename = "#{target}.txt"
	results.push(*results2)
	File.write(filename,results.join("\n"))
end