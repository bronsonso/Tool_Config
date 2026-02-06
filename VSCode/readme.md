To use tasks.json in VSCode, you need to 
- delete tasks.json in the destination folder if existed
- run the follow command in powershell

> # Create symbolic link
> New-Item -ItemType SymbolicLink -Path "C:\Users\bronson.so\AppData\Roaming\Code\User\tasks.json" -Target "C:\Users\bronson.so\Documents\EdCity\Repository\Tool\Config\VSCode\tasks.json"