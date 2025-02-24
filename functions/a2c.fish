# download things with aria2 and 10 connections
function a2c --wraps='aria2c -x 10' --description 'alias a2c=aria2c -x 10'
    aria2c -x 10 $argv     
end