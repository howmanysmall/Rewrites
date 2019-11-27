return function()
	local FasterBase64 = require(script.Parent)
	local t = require(script.Parent.t)

	local ENCODED_STRINGS = {
		{
			Decoded = "Base64";
			Encoded = "QmFzZTY0";
		};

		{
			Decoded = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Feugiat in ante metus dictum at tempor commodo.";
			Encoded = "TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNlY3RldHVyIGFkaXBpc2NpbmcgZWxpdCwgc2VkIGRvIGVpdXNtb2QgdGVtcG9yIGluY2lkaWR1bnQgdXQgbGFib3JlIGV0IGRvbG9yZSBtYWduYSBhbGlxdWEuIEZldWdpYXQgaW4gYW50ZSBtZXR1cyBkaWN0dW0gYXQgdGVtcG9yIGNvbW1vZG8u";
		};

		{
			Decoded = "3.1415926535898";
			Encoded = "My4xNDE1OTI2NTM1ODk4";
		};

		{
			Decoded = "HowManySmall";
			Encoded = "SG93TWFueVNtYWxs";
		};

		{
			Decoded = "Βάση Εξήντα Τέσσερα";
			Encoded = "zpLOrM+DzrcgzpXOvs6uzr3PhM6xIM6kzq3Pg8+DzrXPgc6x";
		};

		{
			Decoded = "Hello, world!";
			Encoded = "SGVsbG8sIHdvcmxkIQ==";
		};

		{
			Decoded = "😊😂👌";
			Encoded = "8J+YivCfmILwn5GM";
		};
	}

	local BASE_64_DICTIONARY = {
		["0"] = true;
		["1"] = true;
		["2"] = true;
		["3"] = true;
		["4"] = true;
		["5"] = true;
		["6"] = true;
		["7"] = true;
		["8"] = true;
		["9"] = true;
		["+"] = true;
		["/"] = true;
		["="] = true;
		A = true;
		a = true;
		B = true;
		b = true;
		c = true;
		C = true;
		d = true;
		D = true;
		E = true;
		e = true;
		f = true;
		F = true;
		g = true;
		G = true;
		h = true;
		H = true;
		i = true;
		I = true;
		J = true;
		j = true;
		K = true;
		k = true;
		l = true;
		L = true;
		m = true;
		M = true;
		n = true;
		N = true;
		O = true;
		o = true;
		p = true;
		P = true;
		Q = true;
		q = true;
		r = true;
		R = true;
		S = true;
		s = true;
		T = true;
		t = true;
		u = true;
		U = true;
		V = true;
		v = true;
		w = true;
		W = true;
		x = true;
		X = true;
		y = true;
		Y = true;
		z = true;
		Z = true;
	}

	local BAD_CHARACTER = "bad character %q in string %q at index %d"

	local function AssertIsBase64(String)
		assert(t.string(String))
		local StringLength = #String
		assert(t.numberPositive(StringLength))

		for Index = 1, StringLength do
			local Character = string.sub(String, Index, Index)
			assert(
				BASE_64_DICTIONARY[Character],
				string.format(BAD_CHARACTER, Character, String, Index)
			)
		end
	end

	describe("Encode", function()
		it("should throw an error if passed argument isn't a string", function()
			expect(function()
				FasterBase64.Encode(1)
			end).to.throw()
		end)

		it("should return a string", function()
			for _, Dictionary in ipairs(ENCODED_STRINGS) do
				expect(FasterBase64.Encode(Dictionary.Decoded)).to.be.a("string")
			end
		end)

		it("should return a Base64 string", function()
			for _, Dictionary in ipairs(ENCODED_STRINGS) do
				expect(function()
					AssertIsBase64(FasterBase64.Encode(Dictionary.Decoded))
				end).never.to.throw()
			end
		end)

		it("should return the correct Base64 string", function()
			for _, Dictionary in ipairs(ENCODED_STRINGS) do
				expect(FasterBase64.Encode(Dictionary.Decoded)).to.equal(Dictionary.Encoded)
			end
		end)
	end)

	describe("Decode", function()
		it("should throw an error if passed argument isn't a string", function()
			expect(function()
				FasterBase64.Decode(1)
			end).to.throw()
		end)

		it("should return a string", function()
			for _, Dictionary in ipairs(ENCODED_STRINGS) do
				expect(FasterBase64.Decode(Dictionary.Encoded)).to.be.a("string")
			end
		end)

		it("should return the correct string", function()
			for _, Dictionary in ipairs(ENCODED_STRINGS) do
				expect(FasterBase64.Decode(Dictionary.Encoded)).to.equal(Dictionary.Decoded)
			end
		end)
	end)
end