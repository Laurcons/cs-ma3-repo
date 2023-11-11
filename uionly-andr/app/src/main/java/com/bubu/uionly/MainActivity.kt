package com.bubu.uionly

import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.bubu.uionly.ui.theme.UIOnlyTheme
import androidx.compose.runtime.*
import androidx.compose.ui.text.style.TextAlign

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            Content()
        }
    }

    @Composable
    private fun Content() {
        val tripLegs = remember { mutableStateListOf<TripLeg>(
            TripLeg("IR 1765", "Cluj Napoca", "Razboieni", "13:45", "15:12", "sa iau cipsuri din gara").apply { setId(1) },
            TripLeg("R 1256", "Razboieni", "Targu Mures", "15:20", "17:34", "").apply { setId(2) }
        ) }
//        tripLegs.clear()
        var nextId by remember { mutableStateOf(3) }
        val onCreateActivity =
            rememberLauncherForActivityResult(ActivityResultContracts.StartActivityForResult()) {
                val trip = it.data?.getSerializableExtra("com.bubu.uionly.result") as TripLeg
                trip.setId(nextId)
                nextId++
                tripLegs.add(it.data?.getSerializableExtra("com.bubu.uionly.result") as TripLeg)
            }
        val onEditActivity =
            rememberLauncherForActivityResult(ActivityResultContracts.StartActivityForResult()) {
                val trip = it.data?.getSerializableExtra("com.bubu.uionly.result") as TripLeg
                val idx = tripLegs.indexOfFirst { t -> t.getId() == trip.getId() }
                tripLegs[idx] = trip;
            }
        val onDeleteActivity =
            rememberLauncherForActivityResult(ActivityResultContracts.StartActivityForResult()) {
                if (it.resultCode == RESULT_OK) {
                    val id = it.data?.getSerializableExtra("com.bubu.uionly.deletedId") as Int
                    val idx = tripLegs.indexOfFirst { t -> t.getId() == id }
                    tripLegs.removeAt(idx)
                }
            }

        fun openCreateActivity() {
            onCreateActivity.launch(Intent(this, CreateTripActivity::class.java))
        }

        fun openEditActivity(trip: TripLeg) {
            val intent = Intent(this, UpdateTripActivity::class.java)
            intent.putExtra("com.bubu.uionly.editedTrip", trip)
            onEditActivity.launch(intent)
        }

        fun openDeleteActivity(trip: TripLeg) {
            val intent = Intent(this, DeleteTripActivity::class.java)
            intent.putExtra("com.bubu.uionly.deletedTrip", trip)
            onDeleteActivity.launch(intent)
        }

        UIOnlyTheme {
            // A surface container using the 'background' color from the theme
            Surface(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(6.dp),
                color = MaterialTheme.colorScheme.background
            ) {
                Column {
                    Text(fontSize = 24.sp, text = "Train Itinerary (alpha 0.0.0rev1)")
                    Row {
                        Spacer(Modifier.weight(1f))
                        Button(onClick = { openCreateActivity() }) {
                            Text(text = "Add trip leg")
                        }
                    }
                    LazyColumn(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                        items(tripLegs) { trip ->
                            ListItem(leg = trip, onEdit = {id ->
                                val leg = tripLegs.first { id == it.getId() }
                                Log.d("MainActivity", "Updating id ${trip.getId()} ${trip.trainNum}")
                                openEditActivity(leg)
                            }, onDelete = {id ->
                                val leg = tripLegs.first { id == it.getId() }
                                openDeleteActivity(leg)
                            })
                            Text(text = "\\/", textAlign = TextAlign.Center, modifier = Modifier
                                .fillMaxWidth()
                                .padding(6.dp))
                        }
                        item {
                            if (tripLegs.count() != 0)
                                Card(elevation = CardDefaults.cardElevation(6.dp), modifier = Modifier.fillMaxWidth()) {
                                    Text(text = "End of your journey. Have a drink! 🍻", modifier = Modifier
                                        .fillMaxWidth()
                                        .padding(6.dp))
                                }
                            else
                                Card(elevation = CardDefaults.cardElevation(6.dp), modifier = Modifier.fillMaxWidth()) {
                                    Text(text = "Go ahead, add a trip leg!", modifier = Modifier
                                        .fillMaxWidth()
                                        .padding(6.dp))
                                }
                        }
                    }
                }
            }
        }
    }
}