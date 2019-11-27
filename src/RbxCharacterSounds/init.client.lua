-- Roblox character sound script

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CreateJanitor = require(script.CreateJanitor)
local WaitForFirst = require(script.WaitForFirst)

local SOUND_DATA = {
	Climbing = {
		SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3";
		Looped = true;
	};

	Died = {SoundId = "rbxasset://sounds/uuhhh.mp3"};
	FreeFalling = {
		SoundId = "rbxasset://sounds/action_falling.mp3";
		Looped = true;
	};

	GettingUp = {SoundId = "rbxasset://sounds/action_get_up.mp3"};
	Jumping = {SoundId = "rbxasset://sounds/action_jump.mp3"};
	Landing = {SoundId = "rbxasset://sounds/action_jump_land.mp3"};

	Running = {
		SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3";
		Looped = true;
		Pitch = 1.85;
	};

	Splash = {SoundId = "rbxasset://sounds/impact_water.mp3"};
	Swimming = {
		SoundId = "rbxasset://sounds/action_swim.mp3";
		Looped = true;
		Pitch = 1.6;
	};
}

local next = next
local ipairs = ipairs

local function PlaySound(Sound)
	Sound.TimePosition = 0
	Sound.Playing = true
end

local function InitializeSoundSystem(Player, Humanoid, RootPart)
	local Sounds = {}
	local Janitor = CreateJanitor()

	for Name, Properties in next, SOUND_DATA do
		local Sound = Instance.new("Sound")
		Sound.Name = Name

		Sound.Archivable = false
		Sound.EmitterSize = 5
		Sound.MaxDistance = 150
		Sound.Volume = 0.65

		for PropertyName, PropertyValue in next, Properties do
			Sound[PropertyName] = PropertyValue
		end

		Sound.Parent = RootPart
		Sounds[Name] = Sound
	end

	local PlayingLoopedSounds = {}

	local function StopPlayingLoopedSounds(Except)
		for Sound in next, PlayingLoopedSounds do
			if Sound ~= Except then
				Sound.Playing = false
				PlayingLoopedSounds[Sound] = nil
			end
		end
	end

	-- state transition callbacks
	local StateTransitions = {
		[Enum.HumanoidStateType.FallingDown] = StopPlayingLoopedSounds;
		[Enum.HumanoidStateType.GettingUp] = function()
			StopPlayingLoopedSounds()
			PlaySound(Sounds.GettingUp)
		end;

		[Enum.HumanoidStateType.Jumping] = function()
			StopPlayingLoopedSounds()
			PlaySound(Sounds.Jumping)
		end;

		[Enum.HumanoidStateType.Swimming] = function()
			local VerticalSpeed = RootPart.Velocity.Y
			VerticalSpeed = VerticalSpeed >= 0 and VerticalSpeed or 0 - VerticalSpeed

			if VerticalSpeed > 0.1 then
				local Volume = (VerticalSpeed - 100) * 0.72 / 250 + 0.28
				Sounds.Splash.Volume = Volume < 0 and 0 or Volume > 1 and 1 or Volume
				PlaySound(Sounds.Splash)
			end

			StopPlayingLoopedSounds(Sounds.Swimming)
			Sounds.Swimming.Playing = true
			PlayingLoopedSounds[Sounds.Swimming] = true
		end;

		[Enum.HumanoidStateType.Freefall] = function()
			Sounds.FreeFalling.Volume = 0
			StopPlayingLoopedSounds(Sounds.FreeFalling)
			PlayingLoopedSounds[Sounds.FreeFalling] = true
		end;

		[Enum.HumanoidStateType.Landed] = function()
			StopPlayingLoopedSounds()
			local VerticalSpeed = RootPart.Velocity.Y
			VerticalSpeed = VerticalSpeed >= 0 and VerticalSpeed or 0 - VerticalSpeed

			if VerticalSpeed > 75 then
				local Volume = (VerticalSpeed - 50) / 50
				Sounds.Landing.Volume = Volume < 0 and 0 or Volume > 1 and 1 or Volume
				PlaySound(Sounds.Landing)
			end
		end;

		[Enum.HumanoidStateType.Running] = function()
			StopPlayingLoopedSounds(Sounds.Running)
			Sounds.Running.Playing = true
			PlayingLoopedSounds[Sounds.Running] = true
		end;

		[Enum.HumanoidStateType.Climbing] = function()
			local Sound = Sounds.Climbing
			local VerticalSpeed = RootPart.Velocity.Y
			VerticalSpeed = VerticalSpeed >= 0 and VerticalSpeed or 0 - VerticalSpeed

			if VerticalSpeed > 0.1 then
				Sound.Playing = true
				StopPlayingLoopedSounds(Sound)
			else
				StopPlayingLoopedSounds()
			end

			PlayingLoopedSounds[Sound] = true
		end;

		[Enum.HumanoidStateType.Seated] = StopPlayingLoopedSounds;
		[Enum.HumanoidStateType.Dead] = function()
			StopPlayingLoopedSounds()
			PlaySound(Sounds.Died)
		end;
	}

	-- updaters for looped sounds
	local LoopedSoundUpdaters = {
		[Sounds.Climbing] = function(_, Sound, Velocity)
			Sound.Playing = Velocity.Magnitude > 0.1
		end;

		[Sounds.FreeFalling] = function(DeltaTime, Sound, Velocity)
			if Velocity.Magnitude > 75 then
				local Volume = Sound.Volume + 0.9 * DeltaTime
				Sound.Volume = Volume < 0 and 0 or Volume > 1 and 1 or Volume
			else
				Sound.Volume = 0
			end
		end;

		[Sounds.Running] = function(_, Sound, Velocity)
			Sound.Playing = Velocity.Magnitude > 0.5 and Humanoid.MoveDirection.Magnitude > 0.5
		end;
	}

	-- state substitutions to avoid duplicating entries in the state table
	local StateRemap = {
		[Enum.HumanoidStateType.RunningNoPhysics] = Enum.HumanoidStateType.Running;
	}

	local ActiveState = StateRemap[Humanoid:GetState()] or Humanoid:GetState()

	Janitor:Add(Humanoid.StateChanged:Connect(function(_, State)
		State = StateRemap[State] or State

		if State ~= ActiveState then
			local TransitionFunction = StateTransitions[State]
			if TransitionFunction then
				TransitionFunction()
			end

			ActiveState = State
		end
	end), "Disconnect")

	Janitor:Add(RunService.Stepped:Connect(function(_, DeltaTime)
		for Sound in next, PlayingLoopedSounds do
			local Updater = LoopedSoundUpdaters[Sound]
			if Updater then
				Updater(DeltaTime, Sound, RootPart.Velocity)
			end
		end
	end), "Disconnect")

	Janitor:Add(Humanoid.AncestryChanged:Connect(function(_, Parent)
		if not Parent then
			Janitor:Cleanup()
		end
	end), "Disconnect")

	Janitor:Add(RootPart.AncestryChanged:Connect(function(_, Parent)
		if not Parent then
			Janitor:Cleanup()
		end
	end), "Disconnect")

	Janitor:Add(Player.CharacterAdded:Connect(function()
		Janitor:Cleanup()
	end), "Disconnect")
end

local function CharacterAddedFenv(Player)
	return function(Character)
		-- Avoiding memory leaks in the face of Character/Humanoid/RootPart lifetime has a few complications:
		-- * character deparenting is a Remove instead of a Destroy, so signals are not cleaned up automatically.
		-- ** must use a waitForFirst on everything and listen for hierarchy changes.
		-- * the character might not be in the dm by the time CharacterAdded fires
		-- ** constantly check consistency with player.Character and abort if CharacterAdded is fired again
		-- * Humanoid may not exist immediately, and by the time it's inserted the character might be deparented.
		-- * RootPart probably won't exist immediately.
		-- ** by the time RootPart is inserted and Humanoid.RootPart is set, the character or the humanoid might be deparented.

		if not Character.Parent then
			local BindableEvent = WaitForFirst(Character.AncestryChanged, Player.CharacterAdded)
			BindableEvent.Event:Wait()
			BindableEvent:Destroy()
		end

		if not (Player.Character ~= Character or not Character.Parent) then
			local Humanoid = Character:FindFirstChildOfClass("Humanoid")

			while Character:IsDescendantOf(game) and not Humanoid do
				local BindableEvent = WaitForFirst(Character.ChildAdded, Character.AncestryChanged, Player.CharacterAdded)
				BindableEvent.Event:Wait()
				BindableEvent:Destroy()
				Humanoid = Character:FindFirstChildOfClass("Humanoid")
			end

			if not (Player.Character ~= Character or not Character:IsDescendantOf(game)) then
				local RootPart = Character:FindFirstChild("HumanoidRootPart")

				while Character:IsDescendantOf(game) and not RootPart do
					local BindableEvent = WaitForFirst(Character.ChildAdded, Character.AncestryChanged, Humanoid.AncestryChanged, Player.CharacterAdded)
					BindableEvent.Event:Wait()
					BindableEvent:Destroy()
					RootPart = Character:FindFirstChild("HumanoidRootPart")
				end

				if RootPart and Humanoid:IsDescendantOf(game) and Character:IsDescendantOf(game) and Player.Character == Character then
					InitializeSoundSystem(Player, Humanoid, RootPart)
				end
			end
		end
	end
end

local function PlayerAdded(Player)
	local CharacterAdded = CharacterAddedFenv(Player)
	if Player.Character then
		CharacterAdded(Player.Character)
	end

	Player.CharacterAdded:Connect(CharacterAdded)
end

Players.PlayerAdded:Connect(PlayerAdded)
for _, Player in ipairs(Players:GetPlayers()) do
	PlayerAdded(Player)
end