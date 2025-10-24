# flight_ticket_booking_card

A beautifully designed, reusable Flutter widget that creates an authentic-looking airline boarding pass/ticket card. Perfect for travel apps, booking confirmations, or any UI that needs a professional ticket design.

## Getting Started

Add the `TicketCard` widget anywhere in your app:

```dart
import 'package:flight_ticket_booking_card/ticket_card.dart';

Scaffold(
  body: Center(
    child: TicketCard(
      fromCode: 'JFK',
      toCode: 'LAX',
      passengerName: 'John Doe',
    ),
  ),
)

```

## Customization

```dart
TicketCard(
  fromCode: 'IST',
  toCode: 'BCN',
  fromTime: '20:15',
  toTime: '23:00',
  dateLabel: 'Fri, 16 August',
  passengerName: 'Jenny Simmons',
  seat: 'B2',
  travelClass: 'Business',
  gate: '41',
  cardBorderRadius: 20,
  cardNotchRadius: 16,
)

```

## Available Parameters

| Parameter               | Type     | Description                               |
|-------------------------|----------|-------------------------------------------|
| `fromCode`              | `String` | Departure airport IATA code (e.g., "DXB") |
| `toCode`                | `String` | Arrival airport IATA code (e.g., "JFK")   |
| `fromTime`              | `String` | Departure time in HH:mm format            |
| `toTime`                | `String` | Arrival time in HH:mm format              |
| `dateLabel`             | `String` | Formatted date label (optional)           |
| `passengerName`         | `String` | Name of the passenger                     |
| `seat`                  | `String` | Seat number (optional)                    |
| `travelClass`           | `String` | Travel class (e.g., Economy, Business)    |
| `gate`                  | `String` | Boarding gate number                      |
| `cardBorderRadius`      | `double` | Outer border corner radius                |
| `cardNotchRadius`       | `double` | Radius for side notches                   |
| `cardNotchOffsetFactor` | `double` | Offset factor for notch placement         |
| `cardBorderWidth`       | `double` | Border width of the ticket                |
| `barcodeData`           | `String` | Data to generate barcode (Code 128)       |

## Features

- Realistic ticket design with rounded corners and notches 
- Customizable flight details and passenger info 
- Perforated cut line separator 
- Barcode area (Code 128)
- Departure and arrival dates **calculated using IATA airport timezones**
- Flight duration displayed in hours and minutes
- Zero dependencies - pure Flutter 
- Responsive (max width: 420px)

For detailed customization options and examples, see the code in lib/flight_ticket_booking_card/ticket_card.dart.

## Screenshots

<img src="https://raw.githubusercontent.com/FazalHussain/Ticket-UI-Widget-Flutter-/refs/heads/master/assets/ticket_card.png" width="360" height="800" alt="Flight Ticket Card">


## License

MIT License

Copyright (c) 2025 Syed Fazal Hussain

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

