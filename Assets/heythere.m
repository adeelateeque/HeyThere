//Facebook login

//On launch, enter details i.e. number, name and etc (Facebook, Twitter and etc).

//Use iBeacons major and minor to idenfity users. major and minor are 16 bit unsigned integers. A total of 2^32 X 2 possible values can be generated ranging from -2^32 to +2^32. 
//If the device doesnt support iBeacons, still go ahead and generate in this manner

//Bind the identifier to user's facebook

//Display photo cards of potentional proximitees. Reveal details on mutual interest

/**
	Proximity Algorithm
*/

//Use iBeacons as the base technology
https://github.com/Instrument/Vicinity also includes background ranging explained here http://stackoverflow.com/questions/18944325/run-iphone-as-an-ibeacon-in-the-background
https://github.com/ohwutup/OWUProximityManager
https://github.com/Estimote/iOS-SDK
 
//Try to set up a beacon every X meters (X being the maximum error tolerated in the system) so we can track on this beacons grid the position of a given device by calculating which beacon on the grid is the closest to the device and assuming that the device is on the same position.
//Trilateration algorithm http://everything2.com/title/Triangulate
- (CGPoint)getCoordinateWithBeaconA:(CGPoint)a beaconB:(CGPoint)b beaconC:(CGPoint)c distanceA:(CGFloat)dA distanceB:(CGFloat)dB distanceC:(CGFloat)dC {
    CGFloat W, Z, x, y, y2;
    W = dA*dA - dB*dB - a.x*a.x - a.y*a.y + b.x*b.x + b.y*b.y;
    Z = dB*dB - dC*dC - b.x*b.x - b.y*b.y + c.x*c.x + c.y*c.y;

    x = (W*(c.y-b.y) - Z*(b.y-a.y)) / (2 * ((b.x-a.x)*(c.y-b.y) - (c.x-b.x)*(b.y-a.y)));
    y = (W - 2*x*(b.x-a.x)) / (2*(b.y-a.y));
    //y2 is a second measure of y to mitigate errors
    y2 = (Z - 2*x*(c.x-b.x)) / (2*(c.y-b.y));

    y = (y + y2) / 2;
    return CGPointMake(x, y);
}


//Add the below ones to the match if available.

//Use GPS to calculate distance between the 2 devices
#define d2r (M_PI / 180.0)

+(float) haversine_km:(float)lat1: (float)long1: (float)lat2: (float)long2
{
	float dlong = (long2 - long1) * d2r;
	float dlat = (lat2 - lat1) * d2r;
	float a = pow(sin(dlat/2.0), 2) + cos(lat1*d2r) * cos(lat2*d2r) * pow(sin(dlong/2.0), 2); 
	float c = 2 * atan2(sqrt(a), sqrt(1-a));
	float d = 6367 * c;

	return d;
}

// Use Bluetooth 
/**
	As soon as a Peripheral is discovered during the scanning, the Central delegate receives the following callback:

		(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI

	This call notifies the Central Manager delegate (the view controller) that a peripheral with advertisement data and RSSI was discovered. 
	RSSI stands for Received Signal Strength Indicator. This is a cool parameter, because knowing the strength of the transmitting signal and the RSSI,
	you can estimate the current distance between the Central and the Peripheral. So, you can use the distance as a filter for a given service: only if 
	the Central is close enough to the Peripheral, then your app does something.
*/


// Use ambient noise
http://mobileorchard.com/tutorial-detecting-when-a-user-blows-into-the-mic/
http://b2cloud.com.au/tutorial/obtaining-decibels-from-the-ios-microphone
https://github.com/urbanclouds/noise-example-ios
https://github.com/leoru/KKNoiseRecognizer
https://github.com/Daij-Djan/MicrophoneBlowDetector

// Use temprature
https://github.com/willsr/21degrees
https://github.com/adba/OpenWeatherMapAPI