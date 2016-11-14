# ZSSN (Zombie Survival Social Network) (Back-End)

This is a repository containing the ZSSN back-end version. This application was developed to acquire a job position at Codeminer 42. This application is a REST API, developed in the ruby on rails language.
Most of the functions are in survivor_controller.rb.

## Endpoints

These are the endpoints of the application.
```
http://localhost:3000/survivors
http://localhost:3000/inventories
http://localhost:3000/stats
```

# cURL 
All the functions developed for this API are listed on a cURL file in bin/curl. The cURL file contains the endpoint URL as well as the function used to submit data in .json files, as it follows. You must edit the .json files in order to use the functions of the API, they are located in the bin folder.

For each of the following to run the command substitue the X for an survivor id. Open the API folder with cd zombie_api, and run the function using bin/curl Y, being Y the name of the function.

## Create Survivors

```
create_survivors(){
curl -v -X POST \
	-H "Content-Type: application/json" \
	-d @bin/survivor.json \
	http://localhost:3000/survivors
}
```

## Create Inventory
```
create_inventory(){
	curl -v -X POST \
	-H "Content-Type: application/json" \
	-d @bin/inventory.json \
	curl http://localhost:3000/survivors/X/inventories	
}
```

## Update Location

```
update_location(){
	curl --request PATCH \
	-H "Content-Type: application/json" \
	-d @bin/update_survivor_location.json \
	http://localhost:3000/survivors/X
}
```

## Flag Infected

```
flag_infected(){
	curl -v -X POST \
	-H "Content-Type: application/json" \
	-d @bin/survivor_flagged.json \
	http://localhost:3000/survivors/X/flag_infected
}
```

## Trade function

In the trade function you send the id of the trader in the trade.json file, as well as the items that you want to trade, then you substitue the X with the id of the survivor that you want to trade.
```
trade(){
	curl -v -X POST \
	-H "Content-Type: application/json" \
	-d @bin/trade.json , 
	http://localhost:3000/survivors/X/trade
}
```
## Reports

```
stats(){
	curl GET \
	http://localhost:3000/stats
}

```
## Cure zombified survivor for creating new inventory purpose

```
unzombiefy(){
	curl --request PATCH \
	-H "Content-Type: application/json" \
	-d @bin/cure.json \
	http://localhost:3000/survivors/1
}
```
