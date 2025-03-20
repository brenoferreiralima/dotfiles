# download videos from yt with yt-dlp in a small size to whatsapp
function yt2wa --wraps='yt-dlp -f 18' --description 'alias a2c=yt-dlp -f 18'
    yt-dlp -f 18 $argv     
end
