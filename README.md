# GMAnalogKit

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

