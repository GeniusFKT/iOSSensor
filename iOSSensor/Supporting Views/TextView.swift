//
//  TextView.swift
//  iOSSensor
//
//  Created by 严铖 on 2020/5/27.
//  Copyright © 2020 kenneth. All rights reserved.
//

import SwiftUI

struct TextView: UIViewRepresentable {

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.contentInset = UIEdgeInsets(top: 5,
            left: 10, bottom: 5, right: 5)
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {

    }
}


struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView()
    }
}
