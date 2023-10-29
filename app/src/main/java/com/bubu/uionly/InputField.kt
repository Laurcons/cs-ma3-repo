package com.bubu.uionly

import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun InputField(label: String, value: String, onValueChange: (String) -> Unit) {
    Row {
        Text(text = label, modifier = Modifier.padding(6.dp))
        Spacer(Modifier.weight(1f))
        OutlinedTextField(value = value, onValueChange = onValueChange, singleLine = true)
    }
}

@Preview
@Composable
fun InputFieldPreview() {
    InputField(label = "Value here:", value = "", onValueChange = {})
}