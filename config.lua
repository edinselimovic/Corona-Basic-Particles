--
-- For more information on config.lua see the Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings

   --calculate the aspect ratio of the device:
local aspectRatio = display.pixelHeight / display.pixelWidth
 
 
application = {
   content = {
      --graphicsCompatibility = 1,  -- This turns on Graphics 1.0 Compatibility mode 
      width = aspectRatio > 1.5 and 640 or math.ceil( 960 / aspectRatio ),
      height = aspectRatio < 1.5 and 960 or math.ceil( 640 * aspectRatio ),
      scale = "letterbox",
      fps = 30,
 
      imageSuffix = {
         ["@2x"] = 1.5,
         ["@4x"] = 3.0,
      },
   },
}