['faraday','erb','json','base64','colorize','set'].each(&method(:require))



def athena(target)
    credentials = File.read('modules/credentials.txt').strip
    resp = Faraday.get("https://api.dehashed.com/search?query=email:@#{target}&page=1&size=10000") do |req|
    	req.headers['Authorization'] = "Basic #{Base64.strict_encode64(credentials)}"
    	req.headers['Accept'] = 'application/json'
    	req.headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.3538.77 Safari/537.36'
    end

    if resp.body =='{"message":"You hit your monthly query limit! Contact support to upgrade plan.","success":false}\n' then
        abort("\n\nOUT OF CREDIT! EXITING...\n\n".red)
      
    elsif resp.body == '{"message":"Invalid API credentials.","success":false}\n' then
    	abort("\n\nInvalid credentials passed!!!\n\n".red)
                
    elsif resp.status != 200 then
    	abort("\n\nRequest failed with a status code of #{resp.status}!!\n\n".red)

    else
        returned = JSON.parse(resp.body)
        response = parsed(returned['entries'])
        response |= []
        puts "\n|Requests:1|Parsed:#{response.length()}|Requests Remaining:#{returned['balance']}|\n".green
        response.append("|Requests:1|Parsed:#{response.length()}|Requests Remaining:#{returned['balance']}|")
        return response.reverse
    end
end



def parsed(text)
    returnable=[]
    begin
        text.each do |i|
            obj = JSON.parse(i.to_json)
            if obj['password'] == '' then
                pass = 1 
            else
                returnable.append("#{obj['email']}:#{obj['password']}")
            end
        end
    rescue
        returnable = []
    end
    return returnable

end

