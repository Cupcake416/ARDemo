//
//  ContentView.swift
//  ARDemo
//
//  Created by 高伟渊 on 2021/5/14.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        arView.environment .sceneUnderstanding.options.insert(.receivesLighting)
        arView.debugOptions.insert(.showSceneUnderstanding)
        arView.automaticallyConfigureSession = false
        let config = ARWorldTrackingConfiguration()
        config.sceneReconstruction = .mesh
        config.planeDetection = .horizontal
        config.environmentTexturing = .automatic
        arView.session.run(config, options: [])
        arView.setupGestures()
        return arView
        
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

extension ARView{
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocatioin = sender.location(in: self)
        if let result = self.raycast(from: tapLocatioin, allowing: .estimatedPlane, alignment: .any).first {
            let resultAnchor = AnchorEntity(world: result.worldTransform)
            resultAnchor.addChild(sphere())
            self.scene.addAnchor(resultAnchor)
        }
    }
}

func sphere() -> ModelEntity {
    let r: Float = 0.05
    let sphere = ModelEntity(mesh: .generateSphere(radius: r), materials: [SimpleMaterial(color: .gray, isMetallic: true)])
    sphere.position.y = r
    return sphere
}
#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
