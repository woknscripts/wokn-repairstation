# wokn-repairstation

ESX Repair Station Script for FiveM

## Features
- Multiple repair station locations with blips
- Costs $1000 from ox_inventory
- Progress bar with disabled movement
- Must be in vehicle to repair
- Fully optimized (0.00ms idle/in-use)
- No performance impact

## Dependencies
- es_extended
- ox_lib
- ox_inventory

## Installation
1. Extract `wokn-repairstation` to your resources folder
2. Add `ensure wokn-repairstation` to your server.cfg
3. Restart your server

## Configuration
Edit `shared/config.lua` to customize:
- Repair cost
- Station locations
- Interaction radius
- Repair duration
- Blip settings

## Usage
Players can use `/repair` when inside a vehicle within 5 units of any repair station.

## Default Locations
- Los Santos (Downtown)
- Sandy Shores
- Paleto Bay
- Los Santos (Airport)
- Los Santos (La Mesa)

## Performance
- Idle: 0.00ms
- Active: 0.00ms
