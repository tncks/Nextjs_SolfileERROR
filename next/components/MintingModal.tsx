import { Text, Modal, ModalOverlay, ModalContent, ModalHeader, ModalCloseButton, ModalBody, ModalFooter, Button } from "@chakra-ui/react";
import { FC } from "react";
import { MINT_GEM_ADDRESS } from "../caverConfig";
import { useAccount, useCaver } from "../hooks";

interface MintingModalProps {
    isOpen: boolean;
    onClose: () => void;
}

const MintingModal: FC<MintingModalProps> = ({ isOpen, onClose }) => {

    const { account } = useAccount();
    const { caver, mintGemContract } = useCaver();

    const onClickMint = async () => {
        try {
            if (!account || !caver || !mintGemContract) return;

            const mintGemResponse = await caver.klay.sendTransaction({
                type: "SMART_CONTRACT_EXECUTION",
                from: account,
                to: MINT_GEM_ADDRESS,
                value: caver.utils.convertToPeb(1, "KLAY"),
                gas: "3000000",
                data: mintGemContract.methods.mintGem().encodeABI()
            });

            //if (mintGemResponse.status) {
                //console.log('hihi');
                //const getTokenResponse = await mintGemContract.methods.getLatestMintedGem(account).call();
            //}

        } catch (error) {
            console.error(error);

        }
    };

    return (
        <Modal isOpen={isOpen} onClose={onClose}>
            <ModalOverlay />
            <ModalContent>
                <ModalHeader>Please Read</ModalHeader>
                <ModalCloseButton />
                <ModalBody>
                    <Text>민팅을 진행하시겠습니까?</Text>
                    <Text>(1 Klay가 소모됩니다.)</Text>
                </ModalBody>

                <ModalFooter>
                    <Button colorScheme="purple" variant="ghost" mr={2} onClick={onClickMint}>
                        민팅하기
                    </Button>
                    <Button colorScheme="gray" onClick={onClose}>
                        닫기
                    </Button>
                </ModalFooter>
            </ModalContent>
        </Modal>
    );
};

export default MintingModal;