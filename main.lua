local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local plr = game.Players.LocalPlayer
local char = plr.Character
local hu = char.HumanoidRootPart
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local contextActionService = game:GetService("ContextActionService")
local flying = false

local Window = Rayfield:CreateWindow({
    Name = "Nick Gui",
    LoadingTitle = "Nick Gui Booting...",
    LoadingSubtitle = "",
    ConfigurationSaving = {
       Enabled = false,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "Big Hub"
    },
    Discord = {
       Enabled = false,
       Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided",
       FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })

 local MainTab = Window:CreateTab("Home", nil) -- Title, Image
 local MainSection = MainTab:CreateSection("Main")

 local Toggle = MainTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        flying = (Value)
    end,
 })

 local Slider = MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {0, 300},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        
    end,
 })

 local Button = MainTab:CreateButton({
    Name = "Fly",
    Callback = function()
        local speed = 30 -- Adjust this for desired speed
        local moving = false
        local storedPosition = hu.Position -- Store initial position to keep the player in place
        
        -- Function to keep the player floating at a fixed position
        local function keepStill()
            hu.Velocity = Vector3.new(0, 0, 0) -- Stop any movement
            hu.CFrame = CFrame.new(storedPosition) -- Keep at the stored position
        end
        
        local function onInputBegan(actionName, inputState, inputObject)
            if inputState == Enum.UserInputState.Begin then
                if actionName == "MoveForward" then
                    moving = true
                end
            end
        end
        
        local function onInputEnded(actionName, inputState, inputObject)
            if inputState == Enum.UserInputState.End then
                if actionName == "MoveForward" then
                    moving = false
                    storedPosition = hu.Position -- Update the stored position when key is released
                end
            end
        end
        
        local function moveInCameraDirection(deltaTime)
            if moving then
                local camera = workspace.CurrentCamera
                local cameraCFrame = camera.CFrame
        
                -- Calculate the movement vector based on the camera's look direction
                local moveDirection = cameraCFrame.LookVector * (speed * deltaTime) -- ensure the multiplication is done inside parentheses
                hu.CFrame = hu.CFrame + moveDirection -- Correctly add a Vector3 to the current CFrame's position
            else
                keepStill()
            end
        end
        
        
        -- Bind the action for moving forward
        contextActionService:BindAction("MoveForward", onInputBegan, false, Enum.KeyCode.W)
        contextActionService:BindAction("StopMoveForward", onInputEnded, false, Enum.KeyCode.W)
        
        -- Update movement every frame
        runService.RenderStepped:Connect(function(deltaTime)
            moveInCameraDirection(deltaTime)
        end)
    end,
 })