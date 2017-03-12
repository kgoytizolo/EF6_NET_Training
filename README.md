# EF6_NET_Training
This repository will include 3 development approaches for a same case, using Entity Framework 6. It will grow from console app to a complex web API through time.

# About Entity Framework - What is?:
- A type of ORM framework.
- ORM: A tool for storing data from: domain objects to relational DB's in an automated way.
  - Parts:
  	- Domain class objects
  	- Relational database objects
  	- Mapping information (To map objects to ER DB objects like stored procedures, tables, etc)
  - What allows?
  	- Keeps the DB design separated the domain class design
  	- This makes the app maintainable and extendable
  	- Automates standard CRUD operations
- Relational data works as domain specific objects
- What ORM implementation provides as services (concepts):
	- Change tracking
	- Identity resolution
	- Lazy loading
	- Query translation
- There are 3 scenarios to implement Entity Framework:
	- Database first: 	Generate Data Access Classes for Existing Database
	- Model first:		Create Database from the domain class
	- Code First:		Create Database and classes from DB model design (based on a model designer from EF)

# Entity Framework architecture:
	- Entity Data Model:
		- Conceptual Model:	Contains model classes and their relationships. Independent from DB table design.
		- Storage Model:	DB design model (DB objects: tables, views, sp's, etc)
		- Mapping:		Information about how conceptual model is mapped to storage model
	- LINQ to Entities
	- Entity SQL
	- Object Service
	- Entity Client Data Provider
	- ADO.Net Data Provider
	
# Entity Framework setup:
	- Distributed in 2 places (Entity Framework 5):
		- NuGet packages	(EntityFramework.dll includes especific features)
		- .NET Framework 	(core API)
	- Just EntityFramework.dll via NuGet (Entity Framework 6)
	
# Setting up a Database (Entity - Relationship Sample for this project):
  - Project: Business Rules for several apps
  	- Entity-Relationship Diagram:
  	- Tables rules to consider:
  	- Relationships to consider:
