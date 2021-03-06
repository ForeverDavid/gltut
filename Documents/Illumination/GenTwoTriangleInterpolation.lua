require "SvgWriter"
require "vmath"
require "Viewport"
require "SubImage"
require "_utils"

local subImageSize = 300;

local subImages = SubImage.SubImage(1, 1, subImageSize, subImageSize, 50, 0);

local coordSize = 2;

local vp = Viewport.Viewport(subImages:SubSize(), {0, 0}, coordSize)
local trans2 = Viewport.Transform2D()
vp:SetTransform(trans2);

local scaleFactor = 0.25;

-- Styles
local styleLib = SvgWriter.StyleLibrary();
local pointSize = 9;
local textSize = 25;

styleLib:AddStyle(nil, "triangle",
	SvgWriter.Style():stroke("black"):fill("none"));
	
styleLib:AddStyle(nil, "triangle_top",
	SvgWriter.Style():stroke("grey"):stroke_width("2px"):stroke_linejoin("round"):fill(SvgWriter.uriLocalElement("top_grad")));
	
styleLib:AddStyle(nil, "triangle_bottom",
	SvgWriter.Style():stroke("grey"):stroke_width("2px"):stroke_linejoin("round"):fill(SvgWriter.uriLocalElement("bottom_grad")));
	

--Vertices
local quadPts =
{
	vmath.vec2(-0.8, 0.8),
	vmath.vec2(0.8, 0.8),
	vmath.vec2(0.8, -0.8),
	vmath.vec2(-0.8, -0.8),
};

quadPts = vp:Transform(quadPts);


--Vertices
local pointRadius = 5;
local radiusPt = vmath.vec2(pointRadius, pointRadius);

local writer = SvgWriter.SvgWriter(ConstructSVGName(arg[0]), {(subImages:Size().x + 1) .."px", (subImages:Size().y + 1) .. "px"});
	writer:StyleLibrary(styleLib);
	writer:BeginDefinitions();
		writer:LinearGradient("top_grad",
			{
				{offset="0%", color="black"},
				{offset="100%", color="#0F0"},
			},
			{"0%", "100%"}, {"50%", "50%"}
		);
		writer:LinearGradient("bottom_grad",
			{
				{offset="0%", color="black"},
				{offset="100%", color="#0F0"},
			},
			{"100%", "0%"}, {"50%", "50%"}
		);
	writer:EndDefinitions();

	writer:Polygon({quadPts[1], quadPts[2], quadPts[3]}, {"triangle_bottom"});
	writer:Polygon({quadPts[1], quadPts[3], quadPts[4]}, {"triangle_top"});
writer:Close();
