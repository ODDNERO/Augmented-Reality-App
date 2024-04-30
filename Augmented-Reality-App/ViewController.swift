//
//  ViewController.swift
//  Augmented-Reality-App
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    
    var markerData = Marker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        for groupName in AssetDataGroup.allCases {
            if let imageGroup = ARReferenceImage.referenceImages(inGroupNamed: groupName.description, bundle: nil) {
                configuration.trackingImages.formUnion(imageGroup)
            }
        }
    
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: any SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        guard let markerName = imageAnchor.referenceImage.name else { return nil }
        guard let marker = markerData[markerName] else { return nil }
        
        // Plane 및 SCNNode 생성
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                             height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = UIColor.clear
    
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
        let node = SCNNode()
        node.addChildNode(planeNode)
        
        // Marker Title Node 생성
        let titleNode = textNode(marker.title, font: UIFont.boldSystemFont(ofSize: 10))
        titleNode.pivotOnTopLeft()
        
        let spacing: Float = 0.005
        titleNode.position.x += Float(plane.width / 2) + spacing
        titleNode.position.y += Float(plane.height / 2)
        planeNode.addChildNode(titleNode)
        
        // Marker Description Node 생성
        let descriptionNode = textNode(marker.description, font: UIFont.systemFont(ofSize: 4), maxWidth: 100)
        descriptionNode.pivotOnTopLeft()

        descriptionNode.position.x += Float(plane.width / 2) + spacing
        descriptionNode.position.y = titleNode.position.y - titleNode.height - spacing
        planeNode.addChildNode(descriptionNode)
        
        return node
    }
    
    func textNode(_ text: String, font: UIFont, maxWidth: Int? = nil) -> SCNNode {
           let text = SCNText(string: text, extrusionDepth: 0)
           text.flatness = 0.1
           text.font = font

           if let maxWidth = maxWidth {
               text.containerFrame = CGRect(origin: .zero, size: CGSize(width: maxWidth, height: 500))
               text.isWrapped = true
           }

           let textNode = SCNNode(geometry: text)
           textNode.scale = SCNVector3(0.002, 0.002, 0.002)

           return textNode
       }

    func loadData() {
            guard let url = Bundle.main.url(forResource: "Marker", withExtension: "json") else {
                fatalError("Unable to find JSON on Bundle")
            }
            guard let data = try? Data(contentsOf: url) else {
                fatalError("Unable to load JSON")
            }
            let decoder = JSONDecoder()
            
            guard let loadedMarkerData = try? decoder.decode([String: AssetsData].self, from: data) else {
                fatalError("Unable to parse JSON")
        }
        markerData = loadedMarkerData
    }
}
