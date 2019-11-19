local empty = {}
local read_write = {read_only = false}
local read_write_class = {read_only = false, other_fields = true}
local read_only = {read_only = true}

local function DefineFields(field_list)
   local fields = {}

   for _, field in ipairs(field_list) do
	  fields[field] = empty
   end

   return{fields = fields}
end

local enum = DefineFields{"Value", "Name"}

local function DefineEnum(field_list)
	local fields = {}

	for _, field in ipairs(field_list) do
		fields[field] = enum
	end

	fields.GetEnumItems = read_only
	return{fields = fields}
end

stds.roblox = {
	globals = {
		script = {
			other_fields = true;
			fields = {
				Source = read_write;
				GetHash = read_write;
				Disabled = read_write;
				LinkedSource = read_write;
				CurrentEditor = read_write_class;
				Archivable = read_write;
				ClassName = read_only;
				DataCost = read_only;
				Name = read_write;
				Parent = read_write_class;
				RobloxLocked = read_write;
				ClearAllChildren = read_write;
				Clone = read_write;
				Destroy = read_write;
				FindFirstAncestor = read_write;
				FindFirstAncestorOfClass = read_write;
				FindFirstAncestorWhichIsA = read_write;
				FindFirstChild = read_write;
				FindFirstChildOfClass = read_write;
				FindFirstChildWhichIsA = read_write;
				GetChildren = read_write;
				GetDebugId = read_write;
				GetDescendants = read_write;
				GetFullName = read_write;
				GetPropertyChangedSignal = read_write;
				IsA = read_write;
				IsAncestorOf = read_write;
				IsDescendantOf = read_write;
				WaitForChild = read_write;
				AncestryChanged = read_write;
				Changed = read_write;
				ChildAdded = read_write;
				ChildRemoved = read_write;
				DescendantAdded = read_write;
				DescendantRemoving = read_write;
			};
		};

		game = {
			other_fields = true;
			fields = {
				CreatorId = read_only;
				CreatorType = read_only;
				GameId = read_only;
				GearGenreSetting = read_only;
				Genre = read_only;
				IsSFFlagsLoaded = read_only;
				JobId = read_only;
				PlaceId = read_only;
				PlaceVersion = read_only;
				PrivateServerId = read_only;
				PrivateServerOwnerId = read_only;
				Workspace = read_only;
				BindToClose = read_write;
				GetJobIntervalPeakFraction = read_write;
				GetJobTimePeakFraction = read_write;
				GetJobsExtendedStats = read_write;
				GetJobsInfo = read_write;
				GetObjects = read_write;
				IsGearTypeAllowed = read_write;
				IsLoaded = read_write;
				Load = read_write;
				OpenScreenshotsFolder = read_write;
				OpenVideosFolder = read_write;
				ReportInGoogleAnalytics = read_write;
				SetPlaceId = read_write;
				SetUniverseId = read_write;
				Shutdown = read_write;
				HttpGetAsync = read_write;
				HttpPostAsync = read_write;
				GraphicsQualityChangeRequest = read_write;
				Loaded = read_write;
				ScreenshotReady = read_write;
				FindService = read_write;
				GetService = read_write;
				Close = read_write;
				CloseLate = read_write;
				ServiceAdded = read_write;
				ServiceRemoving = read_write;
				Archivable = read_write;
				ClassName = read_only;
				DataCost = read_only;
				Name = read_write;
				Parent = read_write_class;
				RobloxLocked = read_write;
				ClearAllChildren = read_write;
				Clone = read_write;
				Destroy = read_write;
				FindFirstAncestor = read_write;
				FindFirstAncestorOfClass = read_write;
				FindFirstAncestorWhichIsA = read_write;
				FindFirstChild = read_write;
				FindFirstChildOfClass = read_write;
				FindFirstChildWhichIsA = read_write;
				GetChildren = read_write;
				GetDebugId = read_write;
				GetDescendants = read_write;
				GetFullName = read_write;
				GetPropertyChangedSignal = read_write;
				IsA = read_write;
				IsAncestorOf = read_write;
				IsDescendantOf = read_write;
				WaitForChild = read_write;
				AncestryChanged = read_write;
				Changed = read_write;
				ChildAdded = read_write;
				ChildRemoved = read_write;
				DescendantAdded = read_write;
				DescendantRemoving = read_write;
			};
		};

		workspace = {
			other_fields = true;
			fields = {
				AllowThirdPartySales = read_write;
				AutoJointsMode = read_write;
				CurrentCamera = read_write_class;
				DistributedGameTime = read_write;
				FallenPartsDestroyHeight = read_write;
				FilteringEnabled = read_write;
				Gravity = read_write;
				StreamingEnabled = read_write;
				StreamingMinRadius = read_write;
				StreamingTargetRadius = read_write;
				TemporaryLegacyPhysicsSolverOverride = read_write;
				Terrain = read_only;
				BreakJoints = read_write;
				ExperimentalSolverIsEnabled = read_write;
				FindPartOnRay = read_write;
				FindPartOnRayWithIgnoreList = read_write;
				FindPartOnRayWithWhitelist = read_write;
				FindPartsInRegion3 = read_write;
				FindPartsInRegion3WithIgnoreList = read_write;
				FindPartsInRegion3WithWhiteList = read_write;
				GetNumAwakeParts = read_write;
				GetPhysicsThrottling = read_write;
				GetRealPhysicsFPS = read_write;
				IsRegion3Empty = read_write;
				IsRegion3EmptyWithIgnoreList = read_write;
				JoinToOutsiders = read_write;
				MakeJoints = read_write;
				PGSIsEnabled = read_write;
				SetPhysicsThrottleEnabled = read_write;
				UnjoinFromOutsiders = read_write;
				ZoomToExtents = read_write;
				PrimaryPart = read_write_class;
				GetBoundingBox = read_write;
				GetExtentsSize = read_write;
				GetPrimaryPartCFrame = read_write;
				MoveTo = read_write;
				SetPrimaryPartCFrame = read_write;
				TranslateBy = read_write;
				Archivable = read_write;
				ClassName = read_only;
				DataCost = read_only;
				Name = read_write;
				Parent = read_write_class;
				RobloxLocked = read_write;
				ClearAllChildren = read_write;
				Clone = read_write;
				Destroy = read_write;
				FindFirstAncestor = read_write;
				FindFirstAncestorOfClass = read_write;
				FindFirstAncestorWhichIsA = read_write;
				FindFirstChild = read_write;
				FindFirstChildOfClass = read_write;
				FindFirstChildWhichIsA = read_write;
				GetChildren = read_write;
				GetDebugId = read_write;
				GetDescendants = read_write;
				GetFullName = read_write;
				GetPropertyChangedSignal = read_write;
				IsA = read_write;
				IsAncestorOf = read_write;
				IsDescendantOf = read_write;
				WaitForChild = read_write;
				AncestryChanged = read_write;
				Changed = read_write;
				ChildAdded = read_write;
				ChildRemoved = read_write;
				DescendantAdded = read_write;
				DescendantRemoving = read_write;
			};
		};
	};

	read_globals = {
		-- Methods
		delay = empty;
		settings = empty;
		spawn = empty;
		tick = empty;
		time = empty;
		typeof = empty;
		version = empty;
		wait = empty;
		warn = empty;
		UserSettings = empty;

		-- Libraries
		bit32 = DefineFields{"band", "extract", "bor", "bnot", "arshift", "rshift", "rrotate", "replace", "lshift", "lrotate", "btest", "bxor"};
		coroutine = DefineFields{"resume", "yield", "running", "status", "wrap", "create", "isyieldable"};
		debug = DefineFields{"traceback", "profileend", "profilebegin"};
		math = DefineFields{"log", "ldexp", "rad", "cosh", "random", "frexp", "tanh", "floor", "max", "sqrt", "modf", "huge", "pow", "atan", "tan", "cos", "sign", "clamp", "log10", "noise", "acos", "abs", "pi", "sinh", "asin", "min", "deg", "fmod", "randomseed", "atan2", "ceil", "sin", "exp"};
		os = DefineFields{"difftime", "time", "date"};
		string = DefineFields{"sub", "split", "upper", "len", "find", "match", "char", "rep", "gmatch", "reverse", "byte", "format", "gsub", "lower"};
		table = DefineFields{"pack", "move", "insert", "getn", "foreachi", "maxn", "foreach", "concat", "unpack", "find", "create", "sort", "remove"};
		utf8 = DefineFields{"offset", "codepoint", "nfdnormalize", "char", "codes", "len", "graphemes", "nfcnormalize", "charpattern"};

		-- Types
		Axes = DefineFields{"new"};
		BrickColor = DefineFields{"Blue", "White", "Yellow", "Red", "Gray", "palette", "New", "Black", "Green", "Random", "DarkGray", "random", "new"};
		CellId = DefineFields{"new"};
		CFrame = DefineFields{"fromMatrix", "fromAxisAngle", "fromOrientation", "fromEulerAnglesXYZ", "Angles", "fromEulerAnglesYXZ", "new"};
		Color3 = DefineFields{"fromHSV", "toHSV", "fromRGB", "new"};
		ColorSequence = DefineFields{"new"};
		ColorSequenceKeypoint = DefineFields{"new"};
		DateTime = DefineFields{"fromIsoDate", "fromUnixTimestamp", "now", "new"};
		DockWidgetPluginGuiInfo = DefineFields{"new"};
		Faces = DefineFields{"new"};
		Instance = DefineFields{"new"};
		NumberRange = DefineFields{"new"};
		NumberSequence = DefineFields{"new"};
		NumberSequenceKeypoint = DefineFields{"new"};
		PathWaypoint = DefineFields{"new"};
		PhysicalProperties = DefineFields{"new"};
		PluginDrag = DefineFields{"new"};
		Random = DefineFields{"new"};
		Ray = DefineFields{"new"};
		Rect = DefineFields{"new"};
		Region3 = DefineFields{"new"};
		Region3int16 = DefineFields{"new"};
		TweenInfo = DefineFields{"new"};
		UDim = DefineFields{"new"};
		UDim2 = DefineFields{"fromOffset", "fromScale", "new"};
		Vector2 = DefineFields{"new"};
		Vector2int16 = DefineFields{"new"};
		Vector3 = DefineFields{"FromNormalId", "FromAxis", "new"};
		Vector3int16 = DefineFields{"new"};

		-- Enums
		Enum = {
			readonly = true;
			fields = {
				ActionType = DefineEnum{"Nothing", "Pause", "Lose", "Draw", "Win"};
				ActuatorRelativeTo = DefineEnum{"Attachment0", "Attachment1", "World"};
				ActuatorType = DefineEnum{"None", "Motor", "Servo"};
				AlignType = DefineEnum{"Parallel", "Perpendicular"};
				AnimationPriority = DefineEnum{"Idle", "Movement", "Action", "Core"};
				AppShellActionType = DefineEnum{"None", "OpenApp", "TapChatTab", "TapConversationEntry", "TapAvatarTab", "ReadConversation", "TapGamePageTab", "TapHomePageTab", "GamePageLoaded", "HomePageLoaded", "AvatarEditorPageLoaded"};
				AspectType = DefineEnum{"FitWithinMaxSize", "ScaleWithParentSize"};
				AssetFetchStatus = DefineEnum{"Success", "Failure"};
				AssetType = DefineEnum{"Image", "TeeShirt", "Audio", "Mesh", "Lua", "Hat", "Place", "Model", "Shirt", "Pants", "Decal", "Head", "Face", "Gear", "Badge", "Animation", "Torso", "RightArm", "LeftArm", "LeftLeg", "RightLeg", "Package", "GamePass", "Plugin", "MeshPart", "HairAccessory", "FaceAccessory", "NeckAccessory", "ShoulderAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory", "ClimbAnimation", "DeathAnimation", "FallAnimation", "IdleAnimation", "JumpAnimation", "RunAnimation", "SwimAnimation", "WalkAnimation", "PoseAnimation", "EarAccessory", "EyeAccessory", "EmoteAnimation"};
				AvatarContextMenuOption = DefineEnum{"Friend", "Chat", "Emote", "InspectMenu"};
				AvatarJointPositionType = DefineEnum{"Fixed", "ArtistIntent"};
				Axis = DefineEnum{"X", "Y", "Z"};
				BinType = DefineEnum{"Script", "GameTool", "Grab", "Clone", "Hammer"};
				BodyPart = DefineEnum{"Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"};
				BodyPartR15 = DefineEnum{"Head", "UpperTorso", "LowerTorso", "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "RightUpperLeg", "LeftHand", "LeftLowerArm", "LeftUpperArm", "RightHand", "RightLowerArm", "RightUpperArm", "RootPart", "Unknown"};
				BorderMode = DefineEnum{"Outline", "Middle", "Inset"};
				BreakReason = DefineEnum{"Other", "Error", "UserBreakpoint", "SpecialBreakpoint"};
				Button = DefineEnum{"Jump", "Dismount"};
				ButtonStyle = DefineEnum{"Custom", "RobloxButtonDefault", "RobloxButton", "RobloxRoundButton", "RobloxRoundDefaultButton", "RobloxRoundDropdownButton"};
				CameraMode = DefineEnum{"Classic", "LockFirstPerson"};
				CameraPanMode = DefineEnum{"Classic", "EdgeBump"};
				CameraType = DefineEnum{"Fixed", "Watch", "Attach", "Track", "Follow", "Custom", "Scriptable", "Orbital"};
				CellBlock = DefineEnum{"Solid", "VerticalWedge", "CornerWedge", "InverseCornerWedge", "HorizontalWedge"};
				CellMaterial = DefineEnum{"Empty", "Grass", "Sand", "Brick", "Granite", "Asphalt", "Iron", "Aluminum", "Gold", "WoodPlank", "WoodLog", "Gravel", "CinderBlock", "MossyStone", "Cement", "RedPlastic", "BluePlastic", "Water"};
				CellOrientation = DefineEnum{"NegZ", "X", "Z", "NegX"};
				CenterDialogType = DefineEnum{"UnsolicitedDialog", "PlayerInitiatedDialog", "ModalDialog", "QuitDialog"};
				ChatCallbackType = DefineEnum{"OnCreatingChatWindow", "OnClientSendingMessage", "OnClientFormattingMessage", "OnServerReceivingMessage"};
				ChatColor = DefineEnum{"Blue", "Green", "Red", "White"};
				ChatMode = DefineEnum{"Menu", "TextAndMenu"};
				ChatPrivacyMode = DefineEnum{"AllUsers", "NoOne", "Friends"};
				ChatStyle = DefineEnum{"Classic", "Bubble", "ClassicAndBubble"};
				CollisionFidelity = DefineEnum{"Default", "Hull", "Box"};
				ComputerCameraMovementMode = DefineEnum{"Default", "Follow", "Classic", "Orbital"};
				ComputerMovementMode = DefineEnum{"Default", "KeyboardMouse", "ClickToMove"};
				ConnectionError = DefineEnum{"OK", "DisconnectErrors", "DisconnectBadhash", "DisconnectSecurityKeyMismatch", "DisconnectNewSecurityKeyMismatch", "DisconnectProtocolMismatch", "DisconnectReceivePacketError", "DisconnectReceivePacketStreamError", "DisconnectSendPacketError", "DisconnectIllegalTeleport", "DisconnectDuplicatePlayer", "DisconnectDuplicateTicket", "DisconnectTimeout", "DisconnectLuaKick", "DisconnectOnRemoteSysStats", "DisconnectHashTimeout", "DisconnectCloudEditKick", "DisconnectPlayerless", "DisconnectEvicted", "DisconnectDevMaintenance", "DisconnectRobloxMaintenance", "DisconnectRejoin", "DisconnectConnectionLost", "DisconnectIdle", "DisconnectRaknetErrors", "DisconnectWrongVersion", "DisconnectBySecurityPolicy", "DisconnectBlockedIP", "PlacelaunchErrors", "PlacelaunchDisabled", "PlacelaunchError", "PlacelaunchGameEnded", "PlacelaunchGameFull", "PlacelaunchUserLeft", "PlacelaunchRestricted", "PlacelaunchUnauthorized", "PlacelaunchFlooded", "PlacelaunchHashExpired", "PlacelaunchHashException", "PlacelaunchPartyCannotFit", "PlacelaunchHttpError", "PlacelaunchCustomMessage", "PlacelaunchOtherError", "TeleportErrors", "TeleportFailure", "TeleportGameNotFound", "TeleportGameEnded", "TeleportGameFull", "TeleportUnauthorized", "TeleportFlooded", "TeleportIsTeleporting"};
				ConnectionState = DefineEnum{"Connected", "Disconnected"};
				ContextActionPriority = DefineEnum{"Low", "Medium", "Default", "High"};
				ContextActionResult = DefineEnum{"Pass", "Sink"};
				ControlMode = DefineEnum{"MouseLockSwitch", "Classic"};
				CoreGuiType = DefineEnum{"PlayerList", "Health", "Backpack", "Chat", "All", "EmotesMenu"};
				CreatorType = DefineEnum{"User", "Group"};
				CurrencyType = DefineEnum{"Default", "Robux", "Tix"};
				CustomCameraMode = DefineEnum{"Default", "Follow", "Classic"};
				DataStoreRequestType = DefineEnum{"GetAsync", "SetIncrementAsync", "UpdateAsync", "GetSortedAsync", "SetIncrementSortedAsync", "OnUpdate"};
				DateTimeKind = DefineEnum{"Utc", "Local"};
				DevCameraOcclusionMode = DefineEnum{"Zoom", "Invisicam"};
				DevComputerCameraMovementMode = DefineEnum{"UserChoice", "Classic", "Follow", "Orbital"};
				DevComputerMovementMode = DefineEnum{"UserChoice", "KeyboardMouse", "ClickToMove", "Scriptable"};
				DevTouchCameraMovementMode = DefineEnum{"UserChoice", "Classic", "Follow", "Orbital"};
				DevTouchMovementMode = DefineEnum{"UserChoice", "Thumbstick", "DPad", "Thumbpad", "ClickToMove", "Scriptable", "DynamicThumbstick"};
				DeveloperMemoryTag = DefineEnum{"Internal", "HttpCache", "Instances", "Signals", "LuaHeap", "Script", "PhysicsCollision", "PhysicsParts", "GraphicsSolidModels", "GraphicsMeshParts", "GraphicsParticles", "GraphicsParts", "GraphicsSpatialHash", "GraphicsTerrain", "GraphicsTexture", "GraphicsTextureCharacter", "Sounds", "StreamingSounds", "TerrainVoxels", "Gui", "Animation", "Navigation"};
				DeviceType = DefineEnum{"Unknown", "Desktop", "Tablet", "Phone"};
				DialogBehaviorType = DefineEnum{"SinglePlayer", "MultiplePlayers"};
				DialogPurpose = DefineEnum{"Quest", "Help", "Shop"};
				DialogTone = DefineEnum{"Neutral", "Friendly", "Enemy"};
				DominantAxis = DefineEnum{"Width", "Height"};
				DraftStatusCode = DefineEnum{"OK", "DraftOutdated", "ScriptRemoved"};
				EasingDirection = DefineEnum{"In", "Out", "InOut"};
				EasingStyle = DefineEnum{"Linear", "Sine", "Back", "Quad", "Quart", "Quint", "Bounce", "Elastic", "Exponential", "Circular", "Cubic"};
				ElasticBehavior = DefineEnum{"WhenScrollable", "Always", "Never"};
				EnviromentalPhysicsThrottle = DefineEnum{"DefaultAuto", "Disabled", "Always", "Skip2", "Skip4", "Skip8", "Skip16"};
				ExplosionType = DefineEnum{"NoCraters", "Craters"};
				FillDirection = DefineEnum{"Horizontal", "Vertical"};
				FilterResult = DefineEnum{"Rejected", "Accepted"};
				Font = DefineEnum{"Legacy", "Arial", "ArialBold", "SourceSans", "SourceSansBold", "SourceSansSemibold", "SourceSansLight", "SourceSansItalic", "Bodoni", "Garamond", "Cartoon", "Code", "Highway", "SciFi", "Arcade", "Fantasy", "Antique", "Gotham", "GothamSemibold", "GothamBold", "GothamBlack"};
				FontSize = DefineEnum{"Size8", "Size9", "Size10", "Size11", "Size12", "Size14", "Size18", "Size24", "Size36", "Size48", "Size28", "Size32", "Size42", "Size60", "Size96"};
				FormFactor = DefineEnum{"Symmetric", "Brick", "Plate", "Custom"};
				FrameStyle = DefineEnum{"Custom", "ChatBlue", "RobloxSquare", "RobloxRound", "ChatGreen", "ChatRed", "DropShadow"};
				FramerateManagerMode = DefineEnum{"Automatic", "On", "Off"};
				FriendRequestEvent = DefineEnum{"Issue", "Revoke", "Accept", "Deny"};
				FriendStatus = DefineEnum{"Unknown", "NotFriend", "Friend", "FriendRequestSent", "FriendRequestReceived"};
				FunctionalTestResult = DefineEnum{"Passed", "Warning", "Error"};
				GameAvatarType = DefineEnum{"R6", "R15", "PlayerChoice"};
				GearGenreSetting = DefineEnum{"AllGenres", "MatchingGenreOnly"};
				GearType = DefineEnum{"MeleeWeapons", "RangedWeapons", "Explosives", "PowerUps", "NavigationEnhancers", "MusicalInstruments", "SocialItems", "BuildingTools", "Transport"};
				Genre = DefineEnum{"All", "TownAndCity", "Fantasy", "SciFi", "Ninja", "Scary", "Pirate", "Adventure", "Sports", "Funny", "WildWest", "War", "SkatePark", "Tutorial"};
				GraphicsMode = DefineEnum{"Automatic", "Direct3D9", "Direct3D11", "OpenGL", "Metal", "Vulkan", "NoGraphics"};
				HandlesStyle = DefineEnum{"Resize", "Movement"};
				HorizontalAlignment = DefineEnum{"Center", "Left", "Right"};
				HoverAnimateSpeed = DefineEnum{"VerySlow", "Slow", "Medium", "Fast", "VeryFast"};
				HttpCachePolicy = DefineEnum{"None", "Full", "DataOnly", "Default", "InternalRedirectRefresh"};
				HttpContentType = DefineEnum{"ApplicationJson", "ApplicationXml", "ApplicationUrlEncoded", "TextPlain", "TextXml"};
				HttpError = DefineEnum{"OK", "InvalidUrl", "DnsResolve", "ConnectFail", "OutOfMemory", "TimedOut", "TooManyRedirects", "InvalidRedirect", "NetFail", "Aborted", "SslConnectFail", "Unknown"};
				HttpRequestType = DefineEnum{"Default", "MarketplaceService", "Players", "Chat", "Avatar", "Analytics", "Localization"};
				HumanoidCollisionType = DefineEnum{"OuterBox", "InnerBox"};
				HumanoidDisplayDistanceType = DefineEnum{"Viewer", "Subject", "None"};
				HumanoidHealthDisplayType = DefineEnum{"DisplayWhenDamaged", "AlwaysOn", "AlwaysOff"};
				HumanoidRigType = DefineEnum{"R6", "R15"};
				HumanoidStateType = DefineEnum{"FallingDown", "Running", "RunningNoPhysics", "Climbing", "StrafingNoPhysics", "Ragdoll", "GettingUp", "Jumping", "Landed", "Flying", "Freefall", "Seated", "PlatformStanding", "Dead", "Swimming", "Physics", "None"};
				InOut = DefineEnum{"Edge", "Inset", "Center"};
				InfoType = DefineEnum{"Asset", "Product", "GamePass", "Subscription", "Bundle"};
				InitialDockState = DefineEnum{"Top", "Bottom", "Left", "Right", "Float"};
				InlineAlignment = DefineEnum{"Bottom", "Center", "Top"};
				InputType = DefineEnum{"NoInput", "Constant", "Sin"};
				JointCreationMode = DefineEnum{"All", "Surface", "None"};
				KeyCode = DefineEnum{"Unknown", "Backspace", "Tab", "Clear", "Return", "Pause", "Escape", "Space", "QuotedDouble", "Hash", "Dollar", "Percent", "Ampersand", "Quote", "LeftParenthesis", "RightParenthesis", "Asterisk", "Plus", "Comma", "Minus", "Period", "Slash", "Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Colon", "Semicolon", "LessThan", "Equals", "GreaterThan", "Question", "At", "LeftBracket", "BackSlash", "RightBracket", "Caret", "Underscore", "Backquote", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "LeftCurly", "Pipe", "RightCurly", "Tilde", "Delete", "KeypadZero", "KeypadOne", "KeypadTwo", "KeypadThree", "KeypadFour", "KeypadFive", "KeypadSix", "KeypadSeven", "KeypadEight", "KeypadNine", "KeypadPeriod", "KeypadDivide", "KeypadMultiply", "KeypadMinus", "KeypadPlus", "KeypadEnter", "KeypadEquals", "Up", "Down", "Right", "Left", "Insert", "Home", "End", "PageUp", "PageDown", "LeftShift", "RightShift", "LeftMeta", "RightMeta", "LeftAlt", "RightAlt", "LeftControl", "RightControl", "CapsLock", "NumLock", "ScrollLock", "LeftSuper", "RightSuper", "Mode", "Compose", "Help", "Print", "SysReq", "Break", "Menu", "Power", "Euro", "Undo", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "F13", "F14", "F15", "World0", "World1", "World2", "World3", "World4", "World5", "World6", "World7", "World8", "World9", "World10", "World11", "World12", "World13", "World14", "World15", "World16", "World17", "World18", "World19", "World20", "World21", "World22", "World23", "World24", "World25", "World26", "World27", "World28", "World29", "World30", "World31", "World32", "World33", "World34", "World35", "World36", "World37", "World38", "World39", "World40", "World41", "World42", "World43", "World44", "World45", "World46", "World47", "World48", "World49", "World50", "World51", "World52", "World53", "World54", "World55", "World56", "World57", "World58", "World59", "World60", "World61", "World62", "World63", "World64", "World65", "World66", "World67", "World68", "World69", "World70", "World71", "World72", "World73", "World74", "World75", "World76", "World77", "World78", "World79", "World80", "World81", "World82", "World83", "World84", "World85", "World86", "World87", "World88", "World89", "World90", "World91", "World92", "World93", "World94", "World95", "ButtonX", "ButtonY", "ButtonA", "ButtonB", "ButtonR1", "ButtonL1", "ButtonR2", "ButtonL2", "ButtonR3", "ButtonL3", "ButtonStart", "ButtonSelect", "DPadLeft", "DPadRight", "DPadUp", "DPadDown", "Thumbstick1", "Thumbstick2"};
				KeywordFilterType = DefineEnum{"Include", "Exclude"};
				Language = DefineEnum{"Default"};
				LanguagePreference = DefineEnum{"SystemDefault", "English", "SimplifiedChinese"};
				LeftRight = DefineEnum{"Left", "Center", "Right"};
				LevelOfDetailSetting = DefineEnum{"High", "Medium", "Low"};
				Limb = DefineEnum{"Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "Unknown"};
				ListDisplayMode = DefineEnum{"Horizontal", "Vertical"};
				ListenerType = DefineEnum{"Camera", "CFrame", "ObjectPosition", "ObjectCFrame"};
				Material = DefineEnum{"Plastic", "Wood", "Slate", "Concrete", "CorrodedMetal", "DiamondPlate", "Foil", "Grass", "Ice", "Marble", "Granite", "Brick", "Pebble", "Sand", "Fabric", "SmoothPlastic", "Metal", "WoodPlanks", "Cobblestone", "Air", "Water", "Rock", "Glacier", "Snow", "Sandstone", "Mud", "Basalt", "Ground", "CrackedLava", "Neon", "Glass", "Asphalt", "LeafyGrass", "Salt", "Limestone", "Pavement", "ForceField"};
				MembershipType = DefineEnum{"None", "BuildersClub", "TurboBuildersClub", "OutrageousBuildersClub", "Premium"};
				MeshType = DefineEnum{"Head", "Torso", "Wedge", "Prism", "Pyramid", "ParallelRamp", "RightAngleRamp", "CornerWedge", "Brick", "Sphere", "Cylinder", "FileMesh"};
				MessageType = DefineEnum{"MessageOutput", "MessageInfo", "MessageWarning", "MessageError"};
				ModifierKey = DefineEnum{"Alt", "Ctrl", "Meta", "Shift"};
				MouseBehavior = DefineEnum{"Default", "LockCenter", "LockCurrentPosition"};
				MoveState = DefineEnum{"Stopped", "Coasting", "Pushing", "Stopping", "AirFree"};
				NameOcclusion = DefineEnum{"OccludeAll", "EnemyOcclusion", "NoOcclusion"};
				NetworkOwnership = DefineEnum{"Automatic", "Manual", "OnContact"};
				NormalId = DefineEnum{"Top", "Bottom", "Back", "Front", "Right", "Left"};
				OutputLayoutMode = DefineEnum{"Horizontal", "Vertical"};
				OverrideMouseIconBehavior = DefineEnum{"None", "ForceShow", "ForceHide"};
				PacketPriority = DefineEnum{"IMMEDIATE_PRIORITY", "HIGH_PRIORITY", "MEDIUM_PRIORITY", "LOW_PRIORITY"};
				PartType = DefineEnum{"Ball", "Block", "Cylinder"};
				PathStatus = DefineEnum{"Success", "ClosestNoPath", "ClosestOutOfRange", "FailStartNotEmpty", "FailFinishNotEmpty", "NoPath"};
				PathWaypointAction = DefineEnum{"Walk", "Jump"};
				PermissionLevelShown = DefineEnum{"Game", "RobloxGame", "RobloxScript", "Studio", "Roblox"};
				Platform = DefineEnum{"Windows", "OSX", "IOS", "Android", "XBoxOne", "PS4", "PS3", "XBox360", "WiiU", "NX", "Ouya", "AndroidTV", "Chromecast", "Linux", "SteamOS", "WebOS", "DOS", "BeOS", "UWP", "None"};
				PlaybackState = DefineEnum{"Begin", "Delayed", "Playing", "Paused", "Completed", "Cancelled"};
				PlayerActions = DefineEnum{"CharacterForward", "CharacterBackward", "CharacterLeft", "CharacterRight", "CharacterJump"};
				PlayerChatType = DefineEnum{"All", "Team", "Whisper"};
				PoseEasingDirection = DefineEnum{"Out", "InOut", "In"};
				PoseEasingStyle = DefineEnum{"Linear", "Constant", "Elastic", "Cubic", "Bounce"};
				PrivilegeType = DefineEnum{"Owner", "Admin", "Member", "Visitor", "Banned"};
				ProductPurchaseDecision = DefineEnum{"NotProcessedYet", "PurchaseGranted"};
				QualityLevel = DefineEnum{"Automatic", "Level01", "Level02", "Level03", "Level04", "Level05", "Level06", "Level07", "Level08", "Level09", "Level10", "Level11", "Level12", "Level13", "Level14", "Level15", "Level16", "Level17", "Level18", "Level19", "Level20", "Level21"};
				R15CollisionType = DefineEnum{"OuterBox", "InnerBox"};
				RenderFidelity = DefineEnum{"Automatic", "Precise"};
				RenderPriority = DefineEnum{"First", "Input", "Camera", "Character", "Last"};
				RenderingTestComparisonMethod = DefineEnum{"psnr", "diff"};
				ReturnKeyType = DefineEnum{"Default", "Done", "Go", "Next", "Search", "Send"};
				ReverbType = DefineEnum{"NoReverb", "GenericReverb", "PaddedCell", "Room", "Bathroom", "LivingRoom", "StoneRoom", "Auditorium", "ConcertHall", "Cave", "Arena", "Hangar", "CarpettedHallway", "Hallway", "StoneCorridor", "Alley", "Forest", "City", "Mountains", "Quarry", "Plain", "ParkingLot", "SewerPipe", "UnderWater"};
				RibbonTool = DefineEnum{"Select", "Scale", "Rotate", "Move", "Transform", "ColorPicker", "MaterialPicker", "Group", "Ungroup", "None"};
				RollOffMode = DefineEnum{"Inverse", "Linear", "InverseTapered", "LinearSquare"};
				RotationType = DefineEnum{"MovementRelative", "CameraRelative"};
				RuntimeUndoBehavior = DefineEnum{"Aggregate", "Snapshot", "Hybrid"};
				SaveFilter = DefineEnum{"SaveAll", "SaveWorld", "SaveGame"};
				SavedQualitySetting = DefineEnum{"Automatic", "QualityLevel1", "QualityLevel2", "QualityLevel3", "QualityLevel4", "QualityLevel5", "QualityLevel6", "QualityLevel7", "QualityLevel8", "QualityLevel9", "QualityLevel10"};
				ScaleType = DefineEnum{"Stretch", "Slice", "Tile", "Fit", "Crop"};
				ScreenOrientation = DefineEnum{"LandscapeLeft", "LandscapeRight", "LandscapeSensor", "Portrait", "Sensor"};
				ScrollBarInset = DefineEnum{"None", "ScrollBar", "Always"};
				ScrollingDirection = DefineEnum{"X", "Y", "XY"};
				ServerAudioBehavior = DefineEnum{"Enabled", "Muted", "OnlineGame"};
				SizeConstraint = DefineEnum{"RelativeXY", "RelativeXX", "RelativeYY"};
				SortOrder = DefineEnum{"LayoutOrder", "Name", "Custom"};
				SoundType = DefineEnum{"NoSound", "Boing", "Bomb", "Break", "Click", "Clock", "Slingshot", "Page", "Ping", "Snap", "Splat", "Step", "StepOn", "Swoosh", "Victory"};
				SpecialKey = DefineEnum{"Insert", "Home", "End", "PageUp", "PageDown", "ChatHotkey"};
				StartCorner = DefineEnum{"TopLeft", "TopRight", "BottomLeft", "BottomRight"};
				Status = DefineEnum{"Poison", "Confusion"};
				StreamingPauseMode = DefineEnum{"Default", "Disabled", "ClientPhysicsPause"};
				StudioDataModelType = DefineEnum{"Edit", "PlayClient", "PlayServer", "RobloxPlugin", "UserPlugin", "None"};
				StudioStyleGuideColor = DefineEnum{"MainBackground", "Titlebar", "Dropdown", "Tooltip", "Notification", "ScrollBar", "ScrollBarBackground", "TabBar", "Tab", "RibbonTab", "RibbonTabTopBar", "Button", "MainButton", "RibbonButton", "ViewPortBackground", "InputFieldBackground", "Item", "TableItem", "CategoryItem", "GameSettingsTableItem", "GameSettingsTooltip", "EmulatorBar", "EmulatorDropDown", "ColorPickerFrame", "CurrentMarker", "Border", "Shadow", "Light", "Dark", "Mid", "MainText", "SubText", "TitlebarText", "BrightText", "DimmedText", "LinkText", "WarningText", "ErrorText", "InfoText", "SensitiveText", "ScriptSideWidget", "ScriptBackground", "ScriptText", "ScriptSelectionText", "ScriptSelectionBackground", "ScriptFindSelectionBackground", "ScriptMatchingWordSelectionBackground", "ScriptOperator", "ScriptNumber", "ScriptString", "ScriptComment", "ScriptPreprocessor", "ScriptKeyword", "ScriptBuiltInFunction", "ScriptWarning", "ScriptError", "DebuggerCurrentLine", "DebuggerErrorLine", "DiffFilePathText", "DiffTextHunkInfo", "DiffTextNoChange", "DiffTextAddition", "DiffTextDeletion", "DiffTextSeparatorBackground", "DiffTextNoChangeBackground", "DiffTextAdditionBackground", "DiffTextDeletionBackground", "DiffLineNum", "DiffLineNumSeparatorBackground", "DiffLineNumNoChangeBackground", "DiffLineNumAdditionBackground", "DiffLineNumDeletionBackground", "DiffFilePathBackground", "DiffFilePathBorder", "Separator", "ButtonBorder", "ButtonText", "InputFieldBorder", "CheckedFieldBackground", "CheckedFieldBorder", "CheckedFieldIndicator", "HeaderSection", "Midlight", "StatusBar", "DialogButton", "DialogButtonText", "DialogButtonBorder", "DialogMainButton", "DialogMainButtonText", "Merge3HighlightOriginal", "Merge3HighlightMine", "Merge3HighlightTheirs"};
				StudioStyleGuideModifier = DefineEnum{"Default", "Selected", "Pressed", "Disabled", "Hover"};
				Style = DefineEnum{"AlternatingSupports", "BridgeStyleSupports", "NoSupports"};
				SurfaceConstraint = DefineEnum{"None", "Hinge", "SteppingMotor", "Motor"};
				SurfaceGuiSizingMode = DefineEnum{"FixedSize", "PixelsPerStud"};
				SurfaceType = DefineEnum{"Smooth", "Glue", "Weld", "Studs", "Inlet", "Universal", "Hinge", "Motor", "SteppingMotor", "SmoothNoOutlines"};
				SwipeDirection = DefineEnum{"Right", "Left", "Up", "Down", "None"};
				TableMajorAxis = DefineEnum{"RowMajor", "ColumnMajor"};
				Technology = DefineEnum{"Compatibility", "Voxel", "ShadowMap", "Legacy"};
				TeleportResult = DefineEnum{"Success", "Failure", "GameNotFound", "GameEnded", "GameFull", "Unauthorized", "Flooded", "IsTeleporting"};
				TeleportState = DefineEnum{"RequestedFromServer", "Started", "WaitingForServer", "Failed", "InProgress"};
				TeleportType = DefineEnum{"ToPlace", "ToInstance", "ToReservedServer"};
				TextFilterContext = DefineEnum{"PublicChat", "PrivateChat"};
				TextInputType = DefineEnum{"Default", "NoSuggestions", "Number", "Email", "Phone", "Password"};
				TextTruncate = DefineEnum{"None", "AtEnd"};
				TextXAlignment = DefineEnum{"Left", "Center", "Right"};
				TextYAlignment = DefineEnum{"Top", "Center", "Bottom"};
				TextureMode = DefineEnum{"Stretch", "Wrap", "Static"};
				TextureQueryType = DefineEnum{"NonHumanoid", "NonHumanoidOrphaned", "Humanoid", "HumanoidOrphaned"};
				ThreadPoolConfig = DefineEnum{"Auto", "PerCore1", "PerCore2", "PerCore3", "PerCore4", "Threads1", "Threads2", "Threads3", "Threads4", "Threads8", "Threads16"};
				ThrottlingPriority = DefineEnum{"Extreme", "ElevatedOnServer", "Default"};
				ThumbnailSize = DefineEnum{"Size48x48", "Size180x180", "Size420x420", "Size60x60", "Size100x100", "Size150x150", "Size352x352"};
				ThumbnailType = DefineEnum{"HeadShot", "AvatarBust", "AvatarThumbnail"};
				TickCountSampleMethod = DefineEnum{"Fast", "Benchmark", "Precise"};
				TopBottom = DefineEnum{"Top", "Center", "Bottom"};
				TouchCameraMovementMode = DefineEnum{"Default", "Follow", "Classic", "Orbital"};
				TouchMovementMode = DefineEnum{"Default", "Thumbstick", "DPad", "Thumbpad", "ClickToMove", "DynamicThumbstick"};
				TweenStatus = DefineEnum{"Canceled", "Completed"};
				UITheme = DefineEnum{"Light", "Dark"};
				UiMessageType = DefineEnum{"UiMessageError", "UiMessageInfo"};
				UploadSetting = DefineEnum{"Never", "Ask", "Always"};
				UserCFrame = DefineEnum{"Head", "LeftHand", "RightHand"};
				UserInputState = DefineEnum{"Begin", "Change", "End", "Cancel", "None"};
				UserInputType = DefineEnum{"MouseButton1", "MouseButton2", "MouseButton3", "MouseWheel", "MouseMovement", "Touch", "Keyboard", "Focus", "Accelerometer", "Gyro", "Gamepad1", "Gamepad2", "Gamepad3", "Gamepad4", "Gamepad5", "Gamepad6", "Gamepad7", "Gamepad8", "TextInput", "InputMethod", "None"};
				VRTouchpad = DefineEnum{"Left", "Right"};
				VRTouchpadMode = DefineEnum{"Touch", "VirtualThumbstick", "ABXY"};
				VerticalAlignment = DefineEnum{"Center", "Top", "Bottom"};
				VerticalScrollBarPosition = DefineEnum{"Left", "Right"};
				VibrationMotor = DefineEnum{"Large", "Small", "LeftTrigger", "RightTrigger", "LeftHand", "RightHand"};
				VideoQualitySettings = DefineEnum{"LowResolution", "MediumResolution", "HighResolution"};
				VirtualInputMode = DefineEnum{"Recording", "Playing", "None"};
				WaterDirection = DefineEnum{"NegX", "X", "NegY", "Y", "NegZ", "Z"};
				WaterForce = DefineEnum{"None", "Small", "Medium", "Strong", "Max"};
				ZIndexBehavior = DefineEnum{"Global", "Sibling"};
			};
		};
	};
}

stds.testez = {
	read_globals = {
		"describe";
		"it", "itFOCUS", "itSKIP";
		"FOCUS", "SKIP", "HACK_NO_XPCALL";
		"expect";
	};
}

stds.plugin = {
	read_globals = {
		"plugin";
		"DebuggerManager";
	};
}

ignore = {
	"241";
}

std = "lua51+roblox"

files["**/*.spec.lua"] = {
	std = "+testez";
}

max_code_line_length = false
max_string_line_length = false
max_comment_line_length = false