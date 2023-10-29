package com.bubu.uionly

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonColors
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import com.bubu.uionly.ui.theme.UIOnlyTheme

class DeleteTripActivity : ComponentActivity() {
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

    @Composable
    fun Content() {
        val trip = intent.getSerializableExtra("com.bubu.uionly.deletedTrip") as TripLeg

        fun returnMessage(res: Boolean) {
            if (res) {
                val intent = Intent()
                intent.putExtra("com.bubu.uionly.deletedId", trip.getId())
                setResult(RESULT_OK, intent)
            } else {
                setResult(RESULT_CANCELED)
            }
            finish()
        }

        Column {
            Text(text = "Are you sure you want to delete this trip leg?")
            Text(text = trip.trainNum)
            Text(text = "${trip.depStation} to ${trip.arrStation}")
            Text(text = "${trip.depTime} to ${trip.arrTime}")
            Button(onClick = { returnMessage(true) }, colors = ButtonDefaults.buttonColors(Color.Red)) {
                Text(text = "Delete")
            }
            Button(onClick = { returnMessage(false) }) {
                Text(text = "Shit! No!")
            }
        }
    }
}