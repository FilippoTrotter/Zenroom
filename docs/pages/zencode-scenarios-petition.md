

<!-- Unused files
 
givenDebugOutputVerbose.json
givenLongOutput.json
 

Link file with relative path: <a href="./_media/examples/zencode_cookbook/givenArraysLoadInput.json">givenArraysLoadInput.json</a>
 
-->


Zenroom's *petition scenario* was developed within [DDDC pilot of the DECODE project](https://decodeproject.eu/pilots) and its cryptography is defined in the [Coconut paper](https://arxiv.org/abs/1802.07344) and uses zero knowledge proof credentials defined in the same paper.
The flow includes: 
 - The creation and approval of a cryptographical petition object.
 - The participant's cryptographical signature of the petition, based on a zero knowledge proof credential.
 - The tally: the cryptographical closing of the petition, counting petitions is not possible before the tally and signing petitions won't be possible afterwards.
 - Counting of the signatures.

The participant's credentials can be anonymous and each participant (or each credential possessor) can only sign the petition once. 

 
## Create the petition: creation and request

Any participant can create a petition. The requirements to become a participant are:
 
 - A key: generated by Zenroom using the *ecdh* or *credential* scenarios
 - A credential: this needs to be produced by a credential issuer and later aggregated with the participant key (using the *credential* scenario) 
 - The credential issuer's public key: this allows the creation and verification to be executed by any party and offline
 
Any participant can create a petition, but the requests needs to later be cryptographically approved by a second peer. The basic script to create a petition and request its approval, *petitionRequest.zen* is: 

[](../_media/examples/zencode_cookbook/zkp/petitionRequest.zen ':include :type=code gherkin')

The script requires the aggregagated credentials from the participant (*credentialParticipantAggregatedCredential.json*), which is created using the *credential* scenario by aggregating:
 - the participant key
 - and a credential, produced by the *credential issuer*, that will be unique for each petition

[](../_media/examples/zencode_cookbook/credential/credentialParticipantAggregatedCredential.json ':include :type=code json')

as well the public key from the credential issuer (*credentialIssuerPublic_key.json*): 

[](../_media/examples/zencode_cookbook/credential/credentialIssuerpublic_key.json ':include :type=code json')

The result should look like this (*petitionRequest.json*):

[](../_media/examples/zencode_cookbook/zkp/petitionRequest.json ':include :type=code json')




## Approve the requested petition

In the second step, theorethically anybody can check if the petition created in the first step is valid and if the creator was allowed to create one. This script can be run by a central verifier or as a smart contract on a blockchain, along with a consensus algorythm.


The script needs as input the *credentialIssuerVerifier.json* (that would ideally be retrieved from a blockchain or web address) and the output of the previous script, the file *petitionRequest.json*. The script to approve the creation of the petition looks like:

[](../_media/examples/zencode_cookbook/zkp/petitionApprove.zen ':include :type=code gherkin')

and if successful the result *petition.json* contains: 
 - crypto-data about the petition 
 - the *issuer public key*, which contain crypto-data aimed to identify the *credential issuer* that produces the credentials used to create, approve and sign the petition.
 
The *petition.json* initially should look like this:

[](../_media/examples/zencode_cookbook/zkp/petitionApproved.json ':include :type=code json')

After the petition has been approved it can be published and signatures can be added (*aggregated*) to it.

## Signing the petition

Once the petition has been created and approved, in the next step, any participant can sign the petition.

The data needed are the *credentialParticipantAggregatedCredential.json* and the *credentialIssuerPublic_key.json*, and the *uid* of the petition itself (in the script below the *uid* is passed as an *inline* value). The credential used by the participant is unique to this petition and can only be **counted** along with signatures produced using similar credentials. A basic script to sign a petition looks like:

[](../_media/examples/zencode_cookbook/zkp/petitionSign.zen ':include :type=code gherkin')

The result *petitionSignature.json* should look like this:

[](../_media/examples/zencode_cookbook/zkp/petitionSignature.json ':include :type=code json')


## Aggregating the signatures: building the signature list 

Each time the petition has been signed, the signature needs to be added to the existing signature, using homomorphic cryptography, the so called *aggregation*. In this step, before performing the aggregation we will:
 - Check the cryptographical validity of each produced *signature*
 - Check that the same participant has not signed the petition already

The script to *aggregate* signatures will be used each time a new signature is produced, it takes as input the latest signature (*petitionSignature.json*) as well as the file *petition.json*, onto which it adds the new signatures. The script looks like this:

[](../_media/examples/zencode_cookbook/zkp/petitionAggregateSignature.zen ':include :type=code gherkin')

The script will be used each time a new signature is produced and should keep modifying the file *petition.json*, which should - in the case of 10 signatures - look like:

[](../_media/examples/zencode_cookbook/zkp/petition.json ':include :type=code json')




## Tally 

The *tally* step effectively closes the petition: 
 - Signatures can be **added** only **before** the tally
 - Signatures can be **counted** only **after** the tally

The script that performs the *tally* takes as input the aggregated signatures *petitionAggregatedSignature.json* and the *credentialParticipantAggregatedCredential.json* file containing the **credentials** of the petition creator, who is the only one who can tally the petition.

The script to *tally* the petition looks like this:

[](../_media/examples/zencode_cookbook/zkp/petitionTally.zen ':include :type=code gherkin')

And the output, *petitionTally.json* should look like:

[](../_media/examples/zencode_cookbook/zkp/petitionTally.json ':include :type=code json')


## Count

The script that counts the signatures can be executed by anyone, it requires no credentials and takes as input:
 - the output of the tally script, the file *petitionTally.json*
 - the petition, which is now containing all the aggregated signatures *petition.json* 

The script to count the signatures looks like this:

[](../_media/examples/zencode_cookbook/zkp/petitionCount.zen ':include :type=code gherkin')

And the output, *petitionCount.json* simply prints out the amount of the signatures (only one in this case) and the petition *uid*. It should look like:

[](../_media/examples/zencode_cookbook/zkp/petitionCount.json ':include :type=code json')


# The script used to create the material in this page

All the smart contracts and the data you see in this page are generated by the petition scripts [zkp.bats](https://github.com/dyne/Zenroom/blob/master/test/zencode/zkp.bats) [zkp_multi_petition.bats](https://github.com/dyne/Zenroom/blob/master/test/zencode/zkp_multi_petitions.bats). If you want to run the script (on Linux) you should: 
 - *git clone https://github.com/dyne/Zenroom.git*
 - install  **jq**
 - download a [zenroom binary](https://zenroom.org/#downloads) and place it */bin* or */usr/bin* or in *./Zenroom/src*
 
Note: in order to execute the petition script, you first need to execute the [credentials' script](https://github.com/dyne/Zenroom/blob/master/test/zencode/zkp.bats) from the [credentials scenario](/pages/zencode-scenario-credentials).
