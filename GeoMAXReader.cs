using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SharpDX;
using BitMiracle.LibTiff.Classic;

namespace GeoMAX
{
    public static class GeoMAXReader
    {

        public static List<float> Read (string filePath, List<Vector2> UVs)
        {
            List<float> heights = new List<float>();
            using (Tiff tiff = Tiff.Open(filePath, "r"))
            {
                foreach (Vector2 UV in UVs)
                {
                    heights.Add(ReadSingle(tiff, UV.X, UV.Y));
                }
            }
            return heights;
        }

        public static float ReadSingle (Tiff tiff, int _X, int _Y)
        {
            float precisePoint = GetHeight(tiff, _X, _Y);

            return precisePoint;
        }
        public static float ReadSingle(Tiff tiff, float _U, float _V)
        {
            int IMGwidth = tiff.GetField(TiffTag.IMAGEWIDTH)[0].ToInt();
            int IMGheight = tiff.GetField(TiffTag.IMAGELENGTH)[0].ToInt();
            int _X = (int)Math.Abs( IMGwidth * _U);
            int _Y = (int)Math.Abs(IMGheight * _V);
            float precisePoint = GetHeight(tiff, _X, _Y);

            return precisePoint;
        }
        private static float GetHeight(Tiff tiff, int _X, int _Y)
        {
            int buffersize = 1000000;
            int tileToSample = tiff.ComputeTile(_X, _Y, 0, 0);
            int nooftiles = tiff.GetField(TiffTag.TILEBYTECOUNTS).Length;
            int TILEwidth = tiff.GetField(TiffTag.TILEWIDTH)[0].ToInt();

            int TILEheight = tiff.GetField(TiffTag.TILELENGTH)[0].ToInt();
            byte[] buffer = new byte[buffersize];

            int size = tiff.ReadEncodedTile(tileToSample, buffer, 0, buffersize);
            float[,] data = new float[TILEwidth, TILEheight];
            Buffer.BlockCopy(buffer, 0, data, 0, size); // Convert byte array to x,y array of floats (height data)
                                                        // Do whatever you want with the height data (calculate hillshade images etc.)

            int X_inside_Tile = _X % TILEwidth;
            int Y_inside_Tile = _Y % TILEheight;

            float precisePoint = data[X_inside_Tile, Y_inside_Tile];

            return precisePoint;
        }
    }
}
