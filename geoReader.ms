scr=(symbolicPaths.getPathValue "$scripts")+ @"\GeoMAX.dll"
stif= (symbolicPaths.getPathValue "$max")+ @"\BitMiracle.LibTiff.NET40.dll"
shp= (symbolicPaths.getPathValue "$max")+ @"\SharpDX.dll"
res=dotnet.loadAssembly scr
atif=dotnet.loadAssembly stif
sdx=dotnet.loadAssembly shp



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