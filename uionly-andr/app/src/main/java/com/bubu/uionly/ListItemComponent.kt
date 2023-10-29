package com.bubu.uionly

import android.util.Log
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.MoreVert
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

@Composable
fun ListItem(leg: TripLeg, onEdit: (id: Int) -> Unit = {}, onDelete: (id: Int) -> Unit = {}) {
    val trainColor: Color =
        if (leg.trainNum.startsWith("IR")) Color.Red
        else if (leg.trainNum.startsWith("IC")) Color(12, 133, 44)
        else Color.Black
    var isMenuOpen by remember { mutableStateOf(false) }
    Card(elevation = CardDefaults.cardElevation(6.dp), modifier = Modifier.fillMaxWidth()) {
        Column {
            Row(modifier = Modifier.padding(8.dp, 6.dp)) {
                Text(text = leg.trainNum, color = trainColor)
                Spacer(Modifier.weight(1f))
                IconButton(modifier = Modifier.padding(0.dp), onClick = { isMenuOpen = !isMenuOpen }) {
                    Icon(Icons.Rounded.MoreVert, "")
                }
                Box {
                    DropdownMenu(expanded = isMenuOpen, onDismissRequest = { isMenuOpen = false }) {
                        DropdownMenuItem(text = { Text(text = "Edit") }, onClick = { onEdit(leg.getId()) })
                        DropdownMenuItem(text = { Text(text = "Delete") }, onClick = { onDelete(leg.getId()) })
                    }
                }
            }
            Row(Modifier.padding(8.dp, 0.dp)) {
                Text(text = leg.depStation)
                Spacer(Modifier.weight(1f))
                Text(text = "to")
                Spacer(Modifier.weight(1f))
                Text(text = leg.arrStation)
            }
            Row(Modifier.padding(8.dp, 0.dp)) {
                Text(text = leg.depTime)
                Spacer(Modifier.weight(1f))
                Text(text = leg.arrTime)
            }
            if (leg.observations.isNotBlank())
                Row(Modifier.padding(8.dp, 0.dp)) {
                    Text(text = leg.observations, color = Color.Gray)
                }
        }
    }
}

@Preview()
@Composable
fun ListItemPreview() {
    ListItem(leg = TripLeg("R3088", "Cluj Napoca", "Unirea hc", "13:45", "14:55", "uh"))
}