# Vintage: Premium Wine Authentication and Provenance Platform

Vintageis a decentralized wine registry built on blockchain technology that enables sommeliers and collectors to authenticate, register, and track premium vintage wines.

## Overview

Vintage creates a trusted platform for wine enthusiasts and professionals to document and preserve wine heritage. The platform allows sommeliers to register wines with verifiable details like vintage year and storage conditions, establishing provenance and authenticity for valuable wine collections.

## Features

- Register premium wines with detailed information (name, cellar notes, region, storage condition)
- Document vintage year for accurate aging and valuation tracking
- Manage cellar status for wine inventory
- Browse wines by region, storage condition, vintage, or sommelier
- Transparent ownership tracking and wine provenance

## Contract Functions

### Public Functions

- `register-wine`: Register a premium wine in the vault registry
- `consume-wine`: Mark a wine as consumed from the cellar
- `get-wine`: Retrieve details about a specific wine bottle
- `get-sommelier`: Get the sommelier who registered a specific wine

### Constants

- Minimum vintage year validation (1800 - modern winemaking era)
- Validation for wine regions and storage conditions
- Error codes for various failure scenarios

## Data Structure

Each wine entry contains:
- Sommelier information (principal)
- Wine name (string)
- Cellar notes and tasting information (string)
- Region classification
- Storage condition assessment
- Cellar status
- Vintage year

## Getting Started

To interact with the VintageVault registry:

1. Deploy the contract to a Stacks blockchain node
2. Call the contract functions using a compatible wallet or Clarity development environment
3. Register your premium wines to establish provenance
4. Browse registered wines from other sommeliers and collectors

## Future Development

- Implement wine trading functionality
- Add professional authentication system
- Create wine valuation and appreciation tracking
- Develop virtual cellar showcases and tasting notes