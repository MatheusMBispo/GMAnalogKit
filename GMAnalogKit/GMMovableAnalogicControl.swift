//
//  GMHUDMovableAnalogicControl.swift
//  GMHUDLayerTest
//
//  Created by Gabriel Rodrigues on 31/05/17.
//  Copyright © 2017 MatheusBispo. All rights reserved.
//

import Foundation
import SpriteKit

/**
 Classe do analógico escondido com área de rastreamento do toque
 */

public class GMMovableAnalogControl : GMAnalogControl {
    
    //MARK: - Variables
    //Identifica se o analógico está sendo clicado ou não
    var isTracking = false
    
    //MARK: - Initializer
    /**
     Inicializador do analógico escondido com área de rastreamento do toque.
     - parameter analogSize: Tamanho do analógico
     - parameter bigTexture: Textura da base do analógico
     - parameter smallTexture: Textura do stick do analógico
     - parameter trackingArea: Área de rastreamento do toque
     */
    public init(analogSize: CGSize, bigTexture: SKTexture, smallTexture: SKTexture, trackingArea: CGSize){
        
        super.init(analogSize: analogSize, bigTexture: bigTexture, smallTexture: smallTexture)
        
        self.size = trackingArea
        self.bigStickNode.alpha = 0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            let touchPoint = touch.location(in: self.scene!)
            
            if self.contains(touchPoint) {
                //Criando uma união com os toques no conjunto analogTouches
                self.analogTouches.formUnion([touch])
                
                //Seta a posicao do analógico e passa os toques para o mesmo
                bigStickNode.position = (touches.first?.location(in: self))!
                bigStickNode.touchesBegan(analogTouches, with: event)
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        //Criando uma intersecçāo com os toques no conjunto analogTouches
        let analogMovedTouches = touches.intersection(analogTouches)
        
        //Verifica se há intersecçāo
        if !analogMovedTouches.isEmpty {
            
            //Passa os toques para a base do analógico
            bigStickNode.touchesMoved(analogMovedTouches, with: event)
            self.bigStickNode.run(SKAction.fadeAlpha(to: 1, duration: 0.1))
            
            //Sinalizado que o analógico está rastreando os toques
            isTracking = true
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        //Criando uma intersecçāo com os toques no conjunto analogTouches
        let analogEndedTouches = touches.intersection(analogTouches)
        
        //Verifica se há intersecçāo
        if !analogEndedTouches.isEmpty {
            
            //Passa os toques para a base do analógico
            bigStickNode.touchesEnded(analogEndedTouches, with: event)
            analogTouches.subtract(analogEndedTouches)
        }
        
        if isTracking {
            self.bigStickNode.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
            //Sinalizado que o analógico não está rastreando os toques
            isTracking = false
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        //Criando uma intersecçāo com os toques no conjunto analogTouches
        let analogCancelledTouches = touches.intersection(analogTouches)
        
        //Verifica se há intersecçāo
        if !analogCancelledTouches
            .isEmpty {
            
            bigStickNode.touchesCancelled(analogCancelledTouches, with: event)
            self.run(SKAction.fadeAlpha(to: 0.1, duration: 0.2))
            //Limapando os toques do conjunto analogTouches
            analogTouches.subtract(analogCancelledTouches)
            
        }
    }
}
