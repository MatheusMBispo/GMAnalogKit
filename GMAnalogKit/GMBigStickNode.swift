//
//  GMBigStickNode.swift
//  FazendoAnalogico
//
//  Created by Matheus Bispo on 21/05/17.
//  Copyright © 2017 MatheusBispo. All rights reserved.
//

import GameplayKit

protocol GMBigStickNodeDelegate: class{
    /**
     Método que alerta a classe que o stick do analógico foi movido e passa as posições do mesmo.
     - parameter analog: Representa o node que está se movendo.
     - parameter xValue: Valor no eixo x da posição do stick dentro do analógico.
     - parameter yValue: Valor no eixo y da posição do stick dentro do analógico.
     */
    func analogDidMoved(analog: GMBigStickNode, xValue: Float, yValue: Float)
}

/**
 Classe da base do analógico
 */
class GMBigStickNode: SKSpriteNode {
    
    //MARK: - Variables
    //Node do stick do analogic
    var smallNode: SKSpriteNode!
    
    //Distancia de rastreamento do toque dentro do GMBigStickNode
    var trackingDistance: CGFloat!

    weak var delegate: GMBigStickNodeDelegate?
    
    //MARK: - Initializer
    /**
        Inicializador do Sprite node da base do analógico
    */
    init(size: CGSize, bigTexture: SKTexture, smallTexture: SKTexture) {

        super.init(texture: bigTexture, color: UIColor.clear, size: size)
        
        //Criando a área de rastreamento com o tamanho da metade da largura do sprite base do analógico
        self.trackingDistance = size.width/2
        
        //Setando o tamanho do stick do analógico
        let smallNodeSize = CGSize(width: size.width/2, height: size.height/2)
    
        //Criando o node do stick dentro do analógico
        smallNode = SKSpriteNode(texture: smallTexture, color: UIColor.clear, size: smallNodeSize)
        
        //Setando o zPosition de modo adequado
        smallNode.zPosition = self.zPosition + 1
        smallNode.name = "smallNode"
        addChild(smallNode)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        //Localizacao do touch
        let touchLocation = touches.first?.location(in: self)
        
        var dx = (touchLocation?.x)!
        var dy = (touchLocation?.y)!
        
        //Distancia entre o centro e o ponto do stick no analógico
        let distance = hypot(dx, dy)
        
        //Ajusta a distancia ao tamanho da base do analógica
        if distance > trackingDistance {
            dx = (dx/distance) * trackingDistance
            dy = (dy/distance) * trackingDistance
        }
        
        //Seta a posicao do stick
        smallNode.position = CGPoint(x: dx, y: dy)
        
        //Normaliza a distancia
        let normalizedDx = Float(dx / trackingDistance)
        let normalizedDy = Float(dy / trackingDistance)
        
        //Faz o envio para o delegate da classe
        delegate?.analogDidMoved(analog: self, xValue: normalizedDx, yValue: normalizedDy)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        //Reseta os dados do analogico
        resetAnalogStick()
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        //Reseta os dados do analogico
        resetAnalogStick()
    }
    
    //MARK: - Methods
    /**
        Reseta a posiçāo do stick no analógico
    */
    func resetAnalogStick(){
        smallNode.run(SKAction.move(to: CGPoint.zero, duration: 0.2))
        
        delegate?.analogDidMoved(analog: self, xValue: 0, yValue: 0)
    }

}
