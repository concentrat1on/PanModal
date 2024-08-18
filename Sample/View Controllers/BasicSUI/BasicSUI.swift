//
//  BasicSUI.swift
//  PanModalDemo
//
//  Created by Illia on 2024-08-17.
//  Copyright © 2024 Detail. All rights reserved.
//

import SwiftUI

#Preview {
    BasicSUI1()
}

struct BasicSUI1: View, BBB {
    
    var scrollViewFound: ((UIScrollView) -> Void)?
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                ScrollDetector {
                    scrollViewFound?($0)
                }
                VStack {
                    ForEach(0..<100, id: \.self) { row in
                        Text("\(row) row")
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        
    }
}

protocol BBB {
    var scrollViewFound: ((UIScrollView) -> Void)? { get set }
}

class HostingController: UIViewController {
    
    private var _scrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = BasicSUI1(scrollViewFound: { [weak self] in
            self?._scrollView = $0
            self?.panModalSetNeedsLayoutUpdate()
        }).makeViewController()
        print(self.view.frame)
        addChild(view)
        view.view.frame = self.view.frame
        self.view.addSubview(view.view)
        
        view.didMove(toParent: self)
    }
    
}

extension HostingController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return _scrollView
    }

    var topOffset: CGFloat {
        return 0.0
    }

    var springDamping: CGFloat {
        return 1.0
    }

    var transitionDuration: Double {
        return 0.4
    }

    var transitionAnimationOptions: UIView.AnimationOptions {
        return [.allowUserInteraction, .beginFromCurrentState]
    }

    var shouldRoundTopCorners: Bool {
        return false
    }

    var showDragIndicator: Bool {
        return false
    }
}

extension View {
    
    func makeViewController() -> UIViewController {
        var content: some View {
            if #available(iOS 16.0, *) {
                return self
            }
            return self.navigationBarHidden(true)
        }
        let controller = UIHostingController(rootView: content)
//        controller.view.backgroundColor = .clear
        return controller
    }
}

struct ScrollDetector: UIViewRepresentable {
    
    //Замыкание в которое будет передаваться текущий offset
    var scrollViewFound: ((UIScrollView) -> Void)?
    
    //Класс-делегат нашего ScrollView
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        var parent: ScrollDetector

        var isDelegateAdded: Bool = false
        
        init(parent: ScrollDetector) {
            self.parent = parent
        }
        
        //методы UIScrollViewDelegate
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            
        }
        
        //тут могли бы быть другие методы UIScrollViewDelegate
        //так как у нас в распоряжении ПОЛНОЦЕННЫЙ ДЕЛЕГАТ от UIKit-ового UIScrollView!
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    //При создании пустой UIView находим UIScrollView и назначаем ему в делегаты наш coordinator
    func makeUIView(context: Context) -> UIView {
        let uiView = UIView()
        DispatchQueue.main.async {
            if let scrollView = recursiveFindScrollView(view: uiView), !context.coordinator.isDelegateAdded {
                scrollView.delegate = context.coordinator
                context.coordinator.isDelegateAdded = true
                scrollViewFound?(scrollView)
            }
        }
        return uiView
    }
    
    //рекурсивно перебираем родителей нашей пустой UIView в поисках ближайшего UIScrollView
    func recursiveFindScrollView(view: UIView) -> UIScrollView? {
        return getAllSubviews(view: findParent(view: view) ?? view, subviews: []).last(where: { NSStringFromClass(type(of: $0)) == "SwiftUI.HostingScrollView" }) as? UIScrollView
    }
    
    func findParent(view: UIView) -> UIView? {
        if let superView = view.superview {
            return findParent(view: superView)
        }
        return view
    }
    
    func getAllSubviews(view: UIView, subviews: [UIView]) -> [UIView] {
        var subviews = subviews
        view.subviews.forEach {
            subviews.append($0)
            getAllSubviews(view: $0, subviews: $0.subviews).forEach { subviews.append($0) }
        }
        return subviews
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
