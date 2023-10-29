package com.bubu.uionly

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.bubu.uionly.ui.theme.UIOnlyTheme
import androidx.compose.runtime.*

class CreateTripActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            UIOnlyTheme {
                Surface(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(6.dp),
                    color = MaterialTheme.colorScheme.background
                ) {
                    Content()
                }
            }
        }
    }

    @OptIn(ExperimentalMaterial3Api::class)
    @Composable
    fun Content() {
//        var trainNum by remember { mutableStateOf("IR1765") }
//        var depStation by remember { mutableStateOf("Raz") }
//        var arrStation by remember { mutableStateOf("Clu") }
//        var depTime by remember { mutableStateOf("14:55") }
//        var arrTime by remember { mutableStateOf("16:23") }
//        var observations by remember { mutableStateOf("") }
        var trainNum by remember { mutableStateOf("") }
        var depStation by remember { mutableStateOf("") }
        var arrStation by remember { mutableStateOf("") }
        var depTime by remember { mutableStateOf("") }
        var arrTime by remember { mutableStateOf("") }
        var observations by remember { mutableStateOf("") }

        fun returnInfo() {
            val trip = TripLeg(trainNum, depStation, arrStation, depTime, arrTime, observations)
            val valid = trip.validate()
            if (!valid.ok) {
                Toast.makeText(applicationContext, valid.message, Toast.LENGTH_LONG).show()
                return
            }
            val intent = Intent()
            intent.putExtra("com.bubu.uionly.result", trip)
            setResult(RESULT_OK, intent)
            finish()
            Toast.makeText(applicationContext, "Trip added", Toast.LENGTH_LONG).show()
        }

        Column {
            Text(fontSize = 24.sp, text = "Add trip leg")
            InputField(label = "Train number", value = trainNum, onValueChange = { trainNum = it })
            Text(fontSize = 20.sp, text = "Departure",modifier = Modifier.padding(6.dp))
            InputField(label = "Station", value = depStation, onValueChange = { depStation = it })
            InputField(label = "Time", value = depTime, onValueChange = { depTime = it })
            Text(fontSize = 20.sp, text = "Arrival", modifier =Modifier.padding(6.dp))
            InputField(label = "Station", value = arrStation, onValueChange = { arrStation = it })
            InputField(label = "Time", value = arrTime, onValueChange = { arrTime = it })
            Text(fontSize = 20.sp, text = "Observations", modifier =Modifier.padding(6.dp))
            OutlinedTextField(value = observations, onValueChange = { observations = it })
            Button(onClick = { returnInfo() }) {
                Text(text = "Create trip leg")
            }
        }
    }
}