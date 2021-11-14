from scripts.helpful_scripts import get_account, get_contract
from brownie import DRTToken, ForRentTransactions, network, config
from web3 import Web3
import yaml
import json
import os
import shutil

initial_supply = Web3.toWei(10000000, "ether")
KEPT_BALANCE = Web3.toWei(1000, "ether")


def update_front_end():
    # Send the build folder
    copy_folders_to_front_end("./build", "./front_end/src/chain-info")

    # Sending the front end our config in JSON format
    with open("brownie-config.yaml", "r") as brownie_config:
        config_dict = yaml.load(brownie_config, Loader=yaml.FullLoader)
        with open("./front_end/src/brownie-config.json", "w") as brownie_config_json:
            json.dump(config_dict, brownie_config_json)
    print("Front end updated!")


def copy_folders_to_front_end(src, dest):
    if os.path.exists(dest):
        shutil.rmtree(dest)
    shutil.copytree(src, dest)


def deploy_for_rent_transaction_and_drt_token(front_end_update=False):
    account = get_account()
    drt_token = DRTToken.deploy(
        initial_supply,
        {"from": account},
        publish_source=config["networks"][network.show_active()]["verify"],
    )
    print("DRTToken deployed!")
    for_rent_transaction = ForRentTransactions.deploy(
        drt_token.address,
        {"from": account},
        publish_source=config["networks"][network.show_active()]["verify"],
    )
    print("ForRent transactions deployed!")

    if front_end_update:
        update_front_end()
    return for_rent_transaction, drt_token


def main():
    deploy_for_rent_transaction_and_drt_token(front_end_update=True)
