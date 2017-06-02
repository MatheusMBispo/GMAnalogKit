# GMAnalogKit

AnalogKit is a framework for SpriteKit projects that provides a fixed Analogic with user defined tracking area.

- Customizable Textures
- Customizable Tracking Area
- Easy for the user

## Touches Configuration
### Configure the touches to use the framework
```
class MyScene: SKScene{

  var analogic: GMAnalogControl

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.analogic.touchesBegan(touches, with: event)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.analogic.touchesMoved(touches, with: event)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.analogic.touchesEnded(touches, with: event)
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.analogic.touchesCancelled(touches, with: event)
  }  
}
```

## Example of a fixed analogic creation:

```
class MyScene: SKScene, GMAnalogDelegate {

  //Creating a fixed analogic
  func creatingFixedAnalogic(){
  
    let bigTexture = SKTexture(imageNamed: "baseJoystick")
    let smallTexture = SKTexture(imageNamed: "baseJoystick")
    let size = CGSize(width: 80, height: 80)
  
    let fixedAnalogic = GMAnalogControl(analogSize: size, bigTexture: bigTexture, smallTexture: smallTexture)
    
    fixedAnalogic.delegate = self
    
    self.addChild(fixedAnalogic)
    
  }
  
   func analogDataUpdated(analogicData: AnalogData){
        //Get the analog data
   }
}
```

## Example of a fixed analogic creation with tracking area:

```
class MyScene: SKScene, GMAnalogDelegate {

  //Creating a fixed analogic
  func creatingFixedAnalogicWithTrackingArea(){
  
    let bigTexture = SKTexture(imageNamed: "baseJoystick")
    let smallTexture = SKTexture(imageNamed: "baseJoystick")
    let size = CGSize(width: 80, height: 80)
    let trackingArea = CGSize(width: 200, height: 200)
  
    let fixedAnalogicWithTrackingArea = GMAnalogControl(analogSize: size, bigTexture: bigTexture, smallTexture: smallTexture, trackingArea: trackingArea)
    
    fixedAnalogicWithTrackingArea.delegate = self
    
    self.addChild(fixedAnalogicWithTrackingArea)
    
  }
  
   func analogDataUpdated(analogicData: AnalogData){
        //Get the analog data
   }
}
```

## Example of a moveable hidden analogic creation:

```
class MyScene: SKScene, GMAnalogDelegate {

  //Creating a fixed analogic
  func creatingHiddenAnalogic(){
  
    let bigTexture = SKTexture(imageNamed: "baseJoystick")
    let smallTexture = SKTexture(imageNamed: "baseJoystick")
    let size = CGSize(width: 80, height: 80)
  
    let hiddenAnalogic = GMMovableAnalogControl(analogSize: size, bigTexture: bigTexture, smallTexture: smallTexture)
    
    hiddenAnalogic.delegate = self
    
    self.addChild(hiddenAnalogic)
    
  }
  
   func analogDataUpdated(analogicData: AnalogData){
        //Get the analog data
   }
}
```
# Warning!

If you don't implement the delegate or don't implement the appropriate touches in your project, the framework will not work properly.
