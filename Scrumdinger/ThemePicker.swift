//
//  ThemePicker.swift
//  Scrumdinger
//
//  Created by Sai Lakshmi on 5/15/22.
//

import SwiftUI

struct ThemePicker: View {
    //This binding communicates changes to the theme within the theme picker, back to the parent view.
    @Binding var selection: Theme
    var body: some View {
        Picker("Theme", selection: $selection) {
            ForEach(Theme.allCases) { theme in
                ThemeView(theme: theme)
                    .tag(theme)
            }
        }
    }
}

struct ThemePicker_Previews: PreviewProvider {
    static var previews: some View {
        //You can use the constant(_:) type method to create a binding to a hard-coded, immutable value. Constant bindings are useful in previews or when prototyping your app’s UI.
        ThemePicker(selection: .constant(.periwinkle))
    }
}
