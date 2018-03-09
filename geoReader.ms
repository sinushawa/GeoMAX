scr=(symbolicPaths.getPathValue "$scripts")+ @"\GeoMAX.dll"
stif= (symbolicPaths.getPathValue "$max")+ @"\BitMiracle.LibTiff.NET40.dll"
shp= (symbolicPaths.getPathValue "$max")+ @"\SharpDX.dll"


fn readHeight =
(
	local res = (dotnetClass "System.Reflection.assembly").Load ((dotnetClass "System.IO.File").ReadAllBytes scr)
	local atif = (dotnetClass "System.Reflection.assembly").Load ((dotnetClass "System.IO.File").ReadAllBytes stif)
	local sdx = (dotnetClass "System.Reflection.assembly").Load ((dotnetClass "System.IO.File").ReadAllBytes shp)
	
	if res != undefined AND shp !=undefined AND atif !=undefined do
	(
		
		
		genericType = dotnet.GetType "System.Collections.Generic.List`1"
		--innerType = dotnet.GetType "SharpDX.Vector2"
		innerType = dotnet.GetType "SharpDX.Point"
		specificType = genericType.MakeGenericType #(innerType)
		filePathBMP = selection[1].mat.diffusemap.fileName
		fileP = getFilenamePath filePathBMP
		fileN = getFilenameFile filePathBMP
		filePath = fileP+fileN+".tif"
		tiffReader = dotNetClass "GeoMAX.GeoMAXReader"
		
		points = (dotnetclass "System.Activator").CreateInstance specificType
		--points.Add (dotnetObject "SharpDX.Vector2" 0.52637 0.53125)
		points.Add (dotnetObject "SharpDX.Point" 5260	5850)
		
		truc=tiffReader.Read filePath points
		print truc
	)
)

fn createGround =
(
	mapchannel = 1
	
	local res = (dotnetClass "System.Reflection.assembly").Load ((dotnetClass "System.IO.File").ReadAllBytes scr)
	local atif = (dotnetClass "System.Reflection.assembly").Load ((dotnetClass "System.IO.File").ReadAllBytes stif)
	local sdx = (dotnetClass "System.Reflection.assembly").Load ((dotnetClass "System.IO.File").ReadAllBytes shp)
	
	if res != undefined AND shp !=undefined AND atif !=undefined do
	(
		genericType = dotnet.GetType "System.Collections.Generic.List`1"
		innerType = dotnet.GetType "SharpDX.Vector2"
		specificType = genericType.MakeGenericType #(innerType)
		
		nBfaces = polyop.getNumMapFaces selection[1] mapchannel
		for i in nBfaces do
		(
			FaceVertices=polyop.getMapFace selection[1] mapchannel i
		)
		
		genericType = dotnet.GetType "System.Collections.Generic.List`1"
		--innerType = dotnet.GetType "SharpDX.Vector2"
		innerType = dotnet.GetType "SharpDX.Point"
		specificType = genericType.MakeGenericType #(innerType)
		filePathBMP = selection[1].mat.diffusemap.fileName
		fileP = getFilenamePath filePathBMP
		fileN = getFilenameFile filePathBMP
		filePath = fileP+fileN+".tif"
		tiffReader = dotNetClass "GeoMAX.GeoMAXReader"
		
		points = (dotnetclass "System.Activator").CreateInstance specificType
		--points.Add (dotnetObject "SharpDX.Vector2" 0.52637 0.53125)
		points.Add (dotnetObject "SharpDX.Point" 5260	5850)
		
		truc=tiffReader.Read filePath points
		print truc
	)
)

function getVertsUVs oPoly mapChannel =
(
	ep = Edit_Poly()--create an Edit_Poly modifier
	addModifier selection[1] ep
	nBfaces = polyop.getNumMapFaces selection[1] mapchannel
	allFaceVertices = #()
	for i=1 to nBfaces do
	(
		FaceVertices=polyop.getMapFace selection[1] mapchannel i
		ep.GetFaceVertex i 
		nbPointsPerFace = ep.GetFaceDegree i
		for j = 1 to nbPointsPerFace do
		(
			VxCorres = #()
			append VxCorres (ep.GetFaceVertex i j)
			append VxCorres (ep.GetMapFaceVert mapChannel i j)
			append allFaceVertices VxCorres
		)
	)
)