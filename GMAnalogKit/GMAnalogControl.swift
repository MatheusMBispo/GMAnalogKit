//
//  GMAnalogic.swift
//  FazendoAnalogico
//
//  Created by Matheus Bispo on 21/05/17.
//  Copyright © 2017 MatheusBispo. All rights reserved.
//

import GameplayKit

/**
    Dados do analógico, contendo a velocidade aplicada no controle analógico e o ângulo do mesmo
 */
public struct AnalogData{
    public var velocity = CGPoint.zero
    public var angle = CGFloat(0)
}

/**
    Delegate da classe GMAnalogControl, utilizado para passar ao usuário os dados do analógico
    sempre que houver uma mudança de valores no mesmo.
 */
public protocol GMAnalogDelegate: class {
    func analogDataUpdated(analogicData: AnalogData)
}

/**
    Classe do analógico fixo e do analógico com área de rastreamento do toque
 */
public class GMAnalogControl: SKSpriteNode {
    
    //MARK: - Variables
    //Node da base do analógico
    var bigStickNode : GMBigStickNode!
    
    //Variável contendo os dados no analógico
    public var data = AnalogData()
    
    //Touches válidos do analógico
    var analogTouches = Set<UITouch>()
    
    //Identifica se o analógico está sendo clicado ou não
    var isTouching = false

    //Delegate do analógico
    public weak var delegate: GMAnalogDelegate?
    
    //MARK: - Initializers
    /**
        Inicializador do analógico fixo sem área de rastreamento do toque.
        - parameter analogSize: Tamanho do analógico
        - parameter bigTexture: Textura da base do analógico
        - parameter smallTexture: Textura do stick do analógico
    */
    public init(analogSize: CGSize, bigTexture: SKTexture, smallTexture: SKTexture) {
        
        super.init(texture: nil, color: UIColor.clear, size: analogSize)
        
        //Cria o node da base do analógico
        bigStickNode = GMBigStickNode(size: analogSize, bigTexture: bigTexture, smallTexture: smallTexture)
        
        //Seta o delegate do node da base
        bigStickNode.delegate = self
        
        //Adicionando o node base no próprio GMAnalogControl
        self.addChild(bigStickNode)
    }
    
    /**
        Inicializador do analógico fixo com área de rastreamento do toque.
         - parameter analogSize: Tamanho do analógico
         - parameter bigTexture: Textura da base do analógico
         - parameter smallTexture: Textura do stick do analógico
         - parameter trackingArea: Área de rastreamento do toque
     */
    public convenience init(analogSize: CGSize, bigTexture: SKTexture, smallTexture: SKTexture, trackingArea: CGSize) {
        
        //Chama o inicializador do analógico fixo
        self.init(analogSize: analogSize, bigTexture: bigTexture, smallTexture: smallTexture)
        
        //Cria uma área em volta do node base do analógico
        self.size = trackingArea
    }
    
    /**
        Inicializador obrigatório utilizado para criar o analógico apartir da sks
    */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        self.setup()
    }
    
    /**
        Setup chamado durante a chamada do sks, criando o analógico na mesma posicao do anchor point do
    Nó pai.
     */
    func setup() {
        
        //Pega o valor da chave "Size" escrita no user data do SKSpriteNode criado na sks
        guard let sizeValue : Double = self.userData?.value(forKey: "Size") as? Double else{
            fatalError("The Value for key 'Size' can't be casted for Double type")
        }
        
        //Pega o valor da chave "BigTexture" escrita no user data do SKSpriteNode criado na sks
        guard let bigTextureValue : String = self.userData?.value(forKey: "BigTexture") as? String else{
            fatalError("The Value for key 'BigTexture' can't be casted for String type")
        }
        
        //Pega o valor da chave "SmallTexture" escrita no user data do SKSpriteNode criado na sks
        guard let smallTextureValue : String = self.userData?.value(forKey: "SmallTexture") as? String else{
            fatalError("The Value for key 'SmallTexture' can't be casted for String type")
        }
        
        //Criando as texturas do analógico
        let bigTexture = SKTexture(imageNamed: bigTextureValue)
        let smallTexture = SKTexture(imageNamed: smallTextureValue)
        
        //Setando o tamanho do analógico
        let size = CGSize(width: sizeValue, height: sizeValue)
        
        //Criando o node base do analógico
        bigStickNode = GMBigStickNode(size: size, bigTexture: bigTexture, smallTexture: smallTexture)
    
        //Setando o delegate do analógico
        bigStickNode.delegate = self
        
        //Adicionando o node base no próprio GMAnalogControl
        self.addChild(bigStickNode)
    }
    
    //MARK: - UI
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        for touch in touches {
            let touchPoint = touch.location(in: self.scene!)
            
            if self.contains(touchPoint) {
                //Criando uma união com os toques no conjunto analogTouches
                self.analogTouches.formUnion([touch])
                
                //Repassa os toques para o sprite da base do analógico
                bigStickNode.touchesBegan(analogTouches, with: event)
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    
        //Criando uma intersecção com os toques no conjunto analogTouches
        let analogMovedTouches = touches.intersection(analogTouches)
        
        if !analogMovedTouches.isEmpty {
            //Repassa os toques para o sprite da base do analógico
            bigStickNode.touchesMoved(analogMovedTouches, with: event)
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        //Criando uma intersecção com os toques no conjunto analogTouches
        let analogEndedTouches = touches.intersection(analogTouches)
        
        if !analogEndedTouches.isEmpty {
            //Repassa os toques para o sprite da base do analógico
            bigStickNode.touchesEnded(analogEndedTouches, with: event)
        
            //Limapando os toques do conjunto analogTouches
            analogTouches.subtract(analogEndedTouches)
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        //Criando uma intersecção com os toques no conjunto analogTouches

        let analogicCancelledTouches = touches.intersection(analogTouches)
        
        if !analogicCancelledTouches
            .isEmpty {
            //Repassa os toques para o sprite da base do analógico
            bigStickNode.touchesCancelled(analogicCancelledTouches, with: event)
        
            //Limapando os toques do conjunto analogTouches
            analogTouches.subtract(analogicCancelledTouches)
            
        }
    }
}

//MARK: - GMBigStickNodeDelegate
/**
 Criando a implementação do delegate do sprite base do analógico
 */
extension GMAnalogControl : GMBigStickNodeDelegate{
    /**
     Esse método trata os dados recebidos e os converte adequadamente para o AnalogData.
     */
    func analogDidMoved(analog: GMBigStickNode, xValue: Float, yValue: Float) {
        data.velocity = CGPoint(x: CGFloat(xValue), y: CGFloat(yValue))
        data.angle = CGFloat(-atan2(xValue, yValue))
        
        delegate?.analogDataUpdated(analogicData: data)
    }
}
